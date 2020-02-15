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
