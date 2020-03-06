# 万葉課題

## テーブル設計

- Usersテーブル
  - name
    - string
  - password
    - string
  - password_digest
    - string
  - admin
    - boolean

- Tasksテーブル
  - name
    - string
  - content
    - text
  - limit
    - data
  - priority(enum使用)
    - integer
  - status(enum使用)
    - integer
  - user_id
    - integer

- Labelsテーブル
  - name
    - string

- Labelingテーブル
  - label_id
    - integer
  - task_id
    - integer

## herokuへのデプロイ方法

1. Herokuでcreate new app
1. Connect GitHubでGitHubと連携
1. Manual Deployでブランチを選択しデプロイ(pumaでエラー吐いたのでバージョンあげた)
1. Consoleでheroku run rails db:migrate(自動pushはmasterブランチにかけたいのでstep2の合格をもらったら実装します)

### Basic認証

1. application_controller.rbに以下のコードを追加

```rb
['BASIC_AUTH_USERNAME'], :password => ENV['BASIC_AUTH_PASSWORD'] if Rails.env == "production"
```

2. Herokuで環境変数をセットする

`heroku config:add BASIC_AUTH_USERNAME="任意のuser名" BASIC_AUTH_PASSWORD="任意のpass"`
