require 'rails_helper'

RSpec.describe 'Users', type: :model do
  before do
    @user = build(:user)
    @admin_user = build(:admin_user)
  end

  describe 'userのバリデーション' do
    example 'name,email,passwordがどれも空文字でなければOK' do
      expect(@user.valid?).to eq(true)
    end

    example 'nameが空だとNG' do
      @user.name = ""
      expect(@user.valid?).to eq(false)
    end

    example 'nameが50文字より多いとNG' do
      @user.name = "qwerty" * 10
      expect(@user.valid?).to eq(false)
    end

    example 'emailが空だとNG' do
      @user.email = ""
      expect(@user.valid?).to eq(false)
    end

    example 'emailがemailの形式でないとNG' do
      @user.email = "qwertyqwerty"
      expect(@user.valid?).to eq(false)
    end
    
    example 'emailがuniqueでないとNG' do
      @user.email = "sample1@example.com"
      @user.save
      @admin_user.email = "sample1@example.com"
      expect(@admin_user.save).to be_falsey # admin_userのemailが@userと同じもので、saveする際に引っかかることをチェックしている
    end

    example 'emailが255文字以下' do
      @user.email = "qwerty" * 50 + "@test.com"
      expect(@user.valid?).to eq(false)
    end

    example 'passwordが空だとNG' do
      @user.password = " "
      expect(@user.save).to be_falsey
    end

    example 'passwordが6文字より少ないとNG' do
      @user.password = "qwert"
      expect(@user.valid?).to eq(false)
    end
  end

  describe 'コールバックのテスト' do
    example '管理者が0になるようなユーザーの削除はNG' do
      expect(@admin_user.destroy).to be_falsey
    end

    example '管理者が0になるようなユーザー情報の編集はNG' do
      @user.save
      @admin_user.save
      expect(@admin_user.update(admin: false)).to be_falsey
    end
  end
end