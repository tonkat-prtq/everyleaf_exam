require 'rails_helper'
require 'selenium-webdriver'
driver = Selenium::WebDriver.for :chrome

RSpec.describe 'Users', type: :system do
  before do
    @user = create(:user)
    @admin_user = create(:admin_user)
  end

  describe 'ユーザー登録画面' do
    before do
      visit new_user_path
    end

    context 'ユーザーのデータがなくログインしていない場合' do
      it 'ユーザー新規登録が出来る' do
        fill_in 'user[name]', with: 'sampleUser'
        fill_in 'user[email]', with: 'sampleuser@test.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_on '登録する'
        expect(current_path).to eq user_path(id: 3)
      end
    end
  end
end