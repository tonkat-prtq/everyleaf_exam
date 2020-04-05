require 'rails_helper'
require 'selenium-webdriver'
driver = Selenium::WebDriver.for :chrome

RSpec.describe 'Users', type: :system do
  before do
    @user = create(:user)
    @admin_user = create(:admin_user)
  end

  describe 'ユーザー登録画面' do
    context 'ユーザーのデータがなくログインしていない場合' do
      example 'ユーザー新規登録が出来る' do
        visit new_user_path
        fill_in 'user[name]', with: 'sampleUser'
        fill_in 'user[email]', with: 'sampleuser@test.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button '登録する'
        expect(page).to have_content "ユーザー登録が完了しました", "sampleuser@test.com"
      end

      context 'タスク一覧に飛ぶと' do
        example 'ログイン画面に戻される' do
          visit root_path
          expect(current_path).to eq new_session_path 
        end
      end
    end

    context 'ユーザーのデータがありログインしている場合' do
      example '自分のユーザーページに移動する' do
        visit new_session_path
        fill_in 'session[email]', with: "admin@example.com"
        fill_in 'session[password]', with: "password"
        click_button 'ログイン'
        visit new_user_path
        expect(current_path).to eq user_path(id: 2)
      end
    end
  end

  describe 'ログイン画面' do
    context '登録済みのユーザーがログインしようとした時' do
      example 'ログインし、自分のユーザー詳細画面に飛ぶ' do
        visit new_session_path
        fill_in 'session[email]', with: 'admin@example.com'
        fill_in 'session[password]', with: 'password'
        click_button 'ログイン'
        expect(current_path).to eq user_path(id: 2)
      end
    end
  end

  describe '一般ユーザーのテスト' do
    before do
      visit new_session_path
      fill_in 'session[email]', with: 'sample1@example.com'
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end

    context '自分の詳細画面に飛んだ時' do
      example '自分のユーザー詳細ページが表示される' do
        visit user_path(id: 1)
        expect(page).to have_content "sample_user1"
      end
    end

    context '他人の詳細画面に飛んだ時' do
      example 'タスク一覧ページに戻される' do
        visit user_path(id: 2)
        expect(current_path).to eq root_path
      end
    end

    context '管理画面にアクセスした時' do
      example 'タスク一覧ページに戻される' do
        visit admin_users_path
        expect(current_path).to eq root_path
      end
    end

    context 'ログアウトボタンを押した時' do
      example 'ログアウト出来る' do
        click_on 'ログアウト'
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe '管理者のテスト' do
    before do
      visit new_session_path
      fill_in 'session[email]', with: 'admin@example.com'
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end

    context '管理者画面にアクセスした時' do
      example 'アクセス出来る' do
        visit admin_users_path
        expect(current_path).to eq admin_users_path
      end
    end

    context '管理者用の新規登録ページで' do
      example 'ユーザーを新規登録できる' do
        visit new_admin_user_path
        fill_in 'user[name]', with: 'sampleUser2'
        fill_in 'user[email]', with: 'sampleuser2@test.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button '登録する'
        expect(page).to have_content "ユーザーを作成しました"
      end
    end

    context '管理者画面から自分以外のユーザー詳細ページに飛ぼうとした時' do
      example 'そのユーザーの詳細ページにアクセス出来る' do
        visit admin_user_path(id: 1)
        expect(current_path).to eq admin_user_path(id: 1)
      end
    end

    context '管理者画面から自分以外のユーザー編集ページに飛んだ時' do
      example 'そのユーザーの編集が出来る' do
        visit edit_admin_user_path(id: 1)
        fill_in 'user[name]', with: 'sampleUser111'
        check '権限'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_on '更新する'
        expect(page).to have_content "ユーザー情報を更新しました"
      end
    end

    context '管理者画面でゴミ箱アイコンを押した時' do
      example 'そのユーザーの削除が出来る' do
        visit admin_users_path
        within first('tbody tr') do
          find('.delete-btn').click
        end

        # 削除ボタンにdelete-btnというクラスをつけたが、adminUserとsampleUserの2人が登録されているので、クラス名だけでfindすると2つ引っかかってしまいエラー
        # 解決策として、within firstで最初の要素だけ取得し、その中のdelete-btnクラスを見つけてクリックさせた

        expect(page).to have_content "ユーザーを削除しました"
      end
    end
  end
end