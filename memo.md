# 多対多で関連付けたデータの検索をコントローラからモデルに移したい

タスク管理アプリに、label（タグ）の検索機能を実装中。参考記事ではコントローラ内にロジックを置いているが、タスク名・ステータスの検索機能と同様、モデルで同じことがしたい。

参考記事
[Railsでラベル機能（タグ付け）を実装する - Qiita](https://qiita.com/harashoo/items/32e9fddf558aaea86267)

```ruby:tasks_controller.rb
@tasks = @tasks
.search_with_name(params[:name])
.search_with_status(params[:status])
.joins(:labels).where(labels: { id: params[:label_id] }) if params[:label_id].present?
```

タスク名・ステータスでの検索（実装済み）

```ruby:models/task.rb
scope :search_with_name, -> (name) {
    return if name.blank?
    where('name LIKE ?', "%#{name}%")
  }
  scope :search_with_status, -> (status) {
    return if status.blank?
    where(status: status)
  }
```

## やったこと

- モデルに同じようなスコープを書いてみる。

```ruby:models/task.rb
  scope :search_with_label, -> (label) {
    return if label.blank?
    joins(:labels).where(id: label)
  }
```

この状態でラベルで検索をすると、一件も取得されない。

発行されているSQLを見てみると

```sql
Task Load (0.4ms)  SELECT  "tasks".* FROM "tasks"
INNER JOIN "labelings" ON "labelings"."task_id" = "tasks"."id"
INNER JOIN "labels" ON "labels"."id" = "labelings"."label_id"
WHERE "tasks"."user_id" = $1 AND "tasks"."id" = $2
ORDER BY "tasks"."created_at" DESC
LIMIT $3 OFFSET $4
[["user_id", 21], ["id", 1], ["LIMIT", 5], ["OFFSET", 0]]
```

labelがロードされてない。
joins(:labels)のあとのwhereが、そのままlabelsにかかってるものだと思ってたけど、どうやらtasksにかかってるよう。

このページを参考に修正。

[関連するモデルの条件で検索したい - Qiita](https://qiita.com/ishidamakot/items/7dba557d764362a828ff#%E7%89%B9%E5%AE%9A%E3%81%AE%E5%95%86%E5%93%81%E3%82%92%E6%B3%A8%E6%96%87%E3%81%97%E3%81%9F%E9%A1%A7%E5%AE%A2%E3%82%92%E6%8A%BD%E5%87%BA)

```ruby:models/task.rb
  scope :search_with_label, -> (label) {
    return if label.blank?
    joins(:labels).where('labels.id = ?', label)
  }
```

`where(id: label)`→`where('labels.id = ?', label)`に。

```sql
Task Load (0.4ms)  
SELECT  "tasks".* FROM "tasks"
INNER JOIN "labelings" ON "labelings"."task_id" = "tasks"."id"
INNER JOIN "labels" ON "labels"."id" = "labelings"."label_id"
WHERE "tasks"."user_id" = $1 AND (labels.id = '1')
ORDER BY "tasks"."created_at" DESC
LIMIT $2 OFFSET $3
[["user_id", 21], ["LIMIT", 5], ["OFFSET", 0]]
```

5行目、whereで絞り込んでいるところで、labels.id = '1'のものを取ってくるようなSQLになってる。

```sql
Label Load (0.2ms)  
SELECT "labels".* FROM "labels"
INNER JOIN "labelings" ON "labels"."id" = "labelings"."label_id"
WHERE "labelings"."task_id" = $1
[["task_id", 16]]
```

その後のSQLでLabel Loadがしっかりかかっている。
labelingテーブルを見てtask_idが16，label_idが1のものを確認している？

## ところでSQLの$マークって何だ

[SQL の構文](https://cellbank.nibiohn.go.jp/legacy/information/pc/postgres_man/sql-syntax.html)

>あとに数字が続くドルマーク($)は、関数定義 の本体中の位置パラメータを表すために使われます。

ちょっとよくわからない……。

### SQLを見てみる

```sql
 Task Load (0.4ms)  
 SELECT  "tasks".* FROM "tasks"
 INNER JOIN "labelings" ON "labelings"."task_id" = "tasks"."id"
 INNER JOIN "labels" ON "labels"."id" = "labelings"."label_id"
 WHERE "tasks"."user_id" = $1 AND "tasks"."id" = $2
 ORDER BY "tasks"."created_at" DESC
 LIMIT $3 OFFSET $4
 [["user_id", 21], ["id", 1], ["LIMIT", 5], ["OFFSET", 0]]
```

`WHERE "tasks"."user_id" = $1`には最終行の1番前にある`"user_id", 21`が、

`AND "tasks"."id" = $2`には`"id", 1`が、

`LIMIT $3 OFFSET $4`にはそれぞれ`"LIMIT", 5`と`"OFFSET", 0`が入りそう。

ここ($マーク内)に送られてきたパラメータ、変数が入りますよっていう印みたいなものという認識で合ってる……？

### そもそもどこから送られてきてる

検索の実装はindexページ。indexページでは自分の作成したタスクのみの表示となっている。

Task Loadの前に発行されているUser LoadのSQL文を見ると、

```sql
User Load (0.2ms)  
SELECT  "users".* FROM "users"
WHERE "users"."id" = $1 LIMIT $2  [["id", 21], ["LIMIT", 1]]
  ↳ app/controllers/application_controller.rb:12
```

矢印でご丁寧に場所を教えてくれてるみたい？見に行ってみる。

```ruby:application_controller.rb
def current_user
  @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
end
```

このメソッドにより、sessionからuser_idを持ってきてるのかな？
コントローラーで実際にcurrent_user.tasksとして現在ログインしてるユーザーのタスク全てを取ってきてるから多分そう。

```ruby:tasks_controller.rb
def index
  @tasks = current_user.tasks

  @tasks = @tasks
  .search_with_name(params[:name])
  .search_with_status(params[:status])
  .search_with_label(params[:label])

  if params[:sort]
    @tasks = @tasks.page(params[:page]).per(PER).order(params[:sort])
  else
    @tasks = @tasks.page(params[:page]).per(PER).default_order
  end
end
```

発行されたSQL全文

```sql
Processing by TasksController#index as HTML
  Parameters: {"utf8"=>"✓", "name"=>"", "status"=>"", "label"=>"1", "search"=>"true", "commit"=>"検索"}
  User Load (0.3ms)
  SELECT  "users".*
  FROM "users"
  WHERE "users"."id" = $1 LIMIT $2
  [["id", 21], ["LIMIT", 1]]
  ↳ app/controllers/application_controller.rb:12
  Rendering tasks/index.html.slim within layouts/application
  
   (0.2ms) SELECT "labels"."name", "labels"."id" FROM "labels"
  ↳ app/views/tasks/index.html.slim:12
  
  Task Load (0.4ms)  
  SELECT  "tasks".*
  FROM "tasks"
  INNER JOIN "labelings" ON "labelings"."task_id" = "tasks"."id"
  INNER JOIN "labels" ON "labels"."id" = "labelings"."label_id"
  WHERE "tasks"."user_id" = $1 AND (labels.id = '1')
  ORDER BY "tasks"."created_at" DESC
  LIMIT $2
  OFFSET $3  
  [["user_id", 21], ["LIMIT", 5], ["OFFSET", 0]]
  ↳ app/views/tasks/index.html.slim:31
  
  Label Load (0.2ms)
  SELECT "labels".*
  FROM "labels"
  INNER JOIN "labelings" ON "labels"."id" = "labelings"."label_id"
  WHERE "labelings"."task_id" = $1  
  [["task_id", 16]]
  ↳ app/views/tasks/index.html.slim:38
```

SQLの11行目はラベルでの検索が書かれているところ。index.html.slimの12行目は

```slim:index.html.slim
h1 = link_to t('.title'), root_path, class: 'text-decoration-none text-reset'
/ ここはlazy lookupで呼び出し

= form_with(method: :get, local: true, url: tasks_path) do |f|
  = f.label :name_search, t('.name_search'), value: params[:name]
  = f.search_field :name, placeholder: t('.name_search'), class: 'form-control'

  = f.label :status_search, t('.status_search'), value: params[:status]
  = f.select :status, Task.enum_options_for_select(:status), class: 'form_control', include_blank: true, selected: ''

  = f.label :label_search, "ラベルで検索", value: params[:label]
  = f.select :label, Label.pluck(:name, :id), { include_blank: true}

  = f.hidden_field :search, value: true
  div.search_button = f.submit(t('.search'), class: 'btn btn-secondary')
```

`Label.pluck(:name, :id)`でselectボックスに選択肢として入れるlabelを取ってきてる。`Label.name`と`Label.id`が入った配列を返してる。

確認

```sql
[1] pry(main)> Label.pluck(:name, :id)
   (0.4ms)  SELECT "labels"."name", "labels"."id" FROM "labels"
=> [["勉強", 1]]
```

### f.selectについて

参考

[フォーム(form) \| Railsドキュメント](https://railsdoc.com/form#select)

>`f.select(メソッド名, 要素(配列 or ハッシュ) [, オプション or HTML属性 or イベント属性])`

要素の配列、ハッシュは、第1引数がセレクトボックスに表示される**表示名**で、第2引数が実際に送られる**値**

この場合は

```text
表示名：勉強
送られる値：id = 1
```

となる。
