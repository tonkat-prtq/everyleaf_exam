require 'rails_helper'
require 'selenium-webdriver'
driver = Selenium::WebDriver.for :chrome

# :timeoutオプションは秒数を指定している。この場合は100秒
wait = Selenium::WebDriver::Wait.new(:timeout => 100) 

RSpec.describe 'Tasks', type: :system do
  before do
    @task = create(:task)
    @new_task = create(:new_task)
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

    describe 'タスクの検索機能' do

      context 'タスク名とステータス名の両方で検索した場合' do
        example 'マッチしたタスクのみが表示される' do
          fill_in 'タスク名で検索', with: "TEST_TASK"
          # find("option[value='未着手']").select_option
          select '未着手', from: :status
          click_button '検索'
          expect(page).to have_text "TEST_TASK", "未着手"
        end
      end

      context 'タスク名のみで検索した場合' do
        before do
          fill_in 'タスク名で検索', with: "TEST_TASK"
          click_button '検索'
        end

        # it_behaves_like 'マッチしたタスクのみが表示される'

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

      example '検索フォームに何も入れなかった場合全てのタスクが表示される' do
        click_button '検索'
        expect(page).to have_text /.*new_test_task.*TEST_TASK.*/m
      end
    end
  end

  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      example 'データが保存されること' do
        # new_task_pathにvisitする（タスク登録ページに遷移する）
        # 1.ここにnew_task_pathにvisitする処理を書く
        visit new_task_path
        # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
        # タスクのタイトルと内容をそれぞれfill_in（入力）する
        # 2.ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in 'タスク名', with: "TEST_TASK"
        # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in '内容', with: "TEST_CONTENT"
        # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
        # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
        fill_in '期限', with: Time.local(2020,2,20,2,2,2)
        click_button '登録する'
        # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
        # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
        # 5.タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
        expect(page).to have_text 'タスクを登録しました'
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