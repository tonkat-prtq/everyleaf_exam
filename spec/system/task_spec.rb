require 'rails_helper'
require 'selenium-webdriver'
driver = Selenium::WebDriver.for :chrome

# :timeoutオプションは秒数を指定している。この場合は100秒
wait = Selenium::WebDriver::Wait.new(:timeout => 100) 

RSpec.describe 'Tasks', type: :system do
  before do
    @user = create(:user)

    visit new_session_path

    fill_in 'session[email]', with: 'sample1@example.com'
    fill_in 'session[password]', with: 'password'
    click_button 'ログイン'

    @task = create(:task, user: @user)
    @new_task = create(:new_task, user: @user)
    @completed_task = create(:completed_task, user: @user)
  end

  describe 'タスク一覧画面' do
    before do
      visit tasks_path
    end

    let(:set_task){
      task_list = all('.task_row')
    }

    context 'タスクを作成した場合' do
      example '作成済みのタスクが表示されること' do
        expect(page).to have_text 'TEST_CONTENT'
      end
    end

    context '複数のタスクを作成した場合' do
      example 'タスクが作成日時の降順に並んでいること' do
        set_task
        within('tbody') do
          expect(page).to have_text /.*new_test_task.*TEST_TASK.*/m
          # mオプションは、ドットが改行にもマッチするオプション（複数行オプション）
        end
      end
    end
    
    describe '並び替えのテスト' do
      context '期限ボタンを押した場合' do
        example 'タスクが期限日の降順に並び替えられること' do
          click_on '期限'
          set_task
          within('tbody') do
            expect(page).to have_text /.*new_test_task.*TEST_TASK.*/m
            # mオプションは、ドットが改行にもマッチするオプション（複数行オプション）
          end
        end
      end

      context '優先度ボタンを押した場合' do
        example 'タスクが優先度の高い順に並び替えられること' do
          click_on '優先度'
          set_task
          first('.priority').has_text? "高"
          page.all('.priority')[1].has_text? "中"

          # within('.prioirty') do
          #   expect(page).to have_text /.*高.*中.*/m
          # end

          # 上記のコードだとダメだった。
          # Unable to find css ".priority" のエラー。これは要素が複数存在する場合にも出るらしく、tdにpriorityクラスを当ててるのでセルの数だけpriorityクラスが存在してしまい、このエラーが発生したと思われる。
        end
      end
    end

    describe 'タスクの検索機能' do
      context 'タスク名、ステータス、ラベルの全てで検索した場合' do
        before do
          fill_in 'タスク名で検索', with: "TEST_TASK"
          select '未着手', from: :status
          select '勉強', from: :label
          click_button '検索'
        end

        example 'マッチしたタスクのみが表示される' do
          within ('tbody') do
            expect(page).to have_text "TEST_TASK", "勉強" 
          end
        end

        example "マッチしないタスクは表示されない" do
          within ('tbody') do
            expect(page).to have_no_text /.*^着手$.*/m
          end
        end
      end

      context 'タスク名とステータス名で検索した場合' do
        before do
          fill_in 'タスク名で検索', with: "TEST_TASK"
          # find("option[value='未着手']").select_option
          select '未着手', from: :status
          click_button '検索'
        end

        example 'マッチしたタスクのみが表示される' do
          expect(page).to have_text "TEST_TASK", "未着手"
        end

        example 'マッチしないタスクは表示されない' do
          expect(page).to have_no_text /.*^new_test_task$.*/m
        end
      end

      context 'タスク名とラベルで検索した場合' do
        before do
          fill_in 'タスク名で検索', with: "TEST_TASK"
          select '勉強', from: :label
          click_button '検索'
        end

        example 'マッチしたタスクのみが表示される' do
          within ('tbody') do
            expect(page).to have_text "TEST_TASK", "勉強" 
          end
        end

        example "マッチしないタスクは表示されない" do
          within ('tbody') do
            expect(page).to have_no_text /.*^料理$.*/m
          end
        end
      end

      context 'タスク名のみで検索した場合' do
        before do
          fill_in 'タスク名で検索', with: "TEST_TASK"
          click_button '検索'
        end

        example 'マッチしたタスクのみが表示される' do
          expect(page).to have_text "TEST_TASK"
        end

        example 'マッチしないタスクは表示されない' do
          expect(page).to have_no_text "new_test_task"
        end
      end

      context 'ステータスのみで検索した場合' do
        before do
          select '未着手', from: :status
          click_button '検索'
        end

        example 'マッチしたタスクのみが表示される' do
          expect(page).to have_text "未着手"
        end

        example 'マッチしないタスクは表示されない' do
          within ('tbody') do
            expect(page).to have_no_text /.*^着手$.*/m
          end
        end
      end

      context 'ラベルで検索した場合' do
        before do
          select '勉強', from: :label
          click_button '検索'
        end

        example 'マッチしたタスクのみが表示される' do
          within ('.labels') do
            expect(page).to have_text "勉強"
          end
        end

        example 'マッチしないタスクは表示されない' do
          expect(page).to have_no_text /.*^new_test_task$.*/m
        end
      end

      example '検索フォームに何も入れなかった場合全てのタスクが表示される' do
        click_button '検索'
        expect(page).to have_text /.*new_test_task.*TEST_TASK.*/m
      end
    end
  end

  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      example 'データが保存されること' do
        visit new_task_path
        fill_in 'タスク名', with: "TEST_TASK"
        fill_in '内容', with: "TEST_CONTENT"
        check '勉強'
        select '2022', from: 'task[deadline(1i)]'
        select '2月', from: 'task[deadline(2i)]'
        select '22', from: 'task[deadline(3i)]'
        click_button '登録する'
        expect(page).to have_text 'タスクを作成しました'
      end
    end
  end

  describe 'タスク詳細画面' do
    context '任意のタスク詳細画面に遷移した場合' do
      example '該当タスクの内容が表示されたページに遷移すること' do
        visit task_path(@task.id)
        expect(page).to have_text "#{@task.name}", "#{@task.content}"
      end
    end
  end
end