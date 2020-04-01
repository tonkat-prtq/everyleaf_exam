require 'rails_helper'

RSpec.describe 'Tasks', type: :model do
  before do
    @user = build(:user)
    @task = build(:task, user: @user)
    @new_task = build(:new_task, user: @user)
    @completed_task = build(:completed_task, user: @user)
  end

  describe 'taskのバリデーション' do
    example 'name,content,deadlineがどれも空文字ではなければOK' do
      expect(@task.valid?).to eq(true)
    end

    example 'nameが空だとNG' do
      @task.name = ''
      expect(@task.valid?).to eq(false)
    end

    example 'contentが空だとNG' do
      @task.content = ''
      expect(@task.valid?).to eq(false)
    end

    example 'deadlineが空だとNG' do
      @task.deadline = ''
      expect(@task.valid?).to eq(false)
    end

  end

  describe '検索のテスト' do
    before do
      @user = create(:user)
      @task = create(:task, user: @user)
      @new_task = create(:new_task, user: @user)
      @completed_task = create(:completed_task, user: @user)
    end
    
    describe 'タスク名のみの検索' do
      example '検索したタスク名が入っている' do
        expect(Task.search_with_name("new_test_task")).to include(@new_task)
      end

      example 'タスク名にマッチしない場合はNG' do
        expect(Task.search_with_name("no_match")).to_not include(@new_task, @task, @completed_task)
      end
    end

    describe 'ステータスのみの検索' do
      example '検索したステータスのみ表示される' do
        expect(Task.search_with_status(:working)).to include(@new_task)
      end

      example 'ステータス名にマッチしない場合はNG' do
        expect(Task.search_with_status(:working)).to_not include(@task, @completed_task)
      end
    end

    describe 'タスク名とステータス名両方での検索' do
      example 'どちらの検索条件にも引っかかるタスクがマッチする' do
        expect(Task.search_with_name("new_test_task").search_with_status(:working)).to include(@new_task)
      end

      example 'タスク名のみマッチしてもステータスがマッチしなければ検索結果は得られない' do
        expect(Task.search_with_name("new_test_task").search_with_status(:waiting)).to_not include(@new_task)
      end

      example 'ステータスのみマッチしてもタスク名がマッチしなければ検索結果は得られない' do
        expect(Task.search_with_name("qwerty").search_with_status(:working)).to_not include(@new_task)
      end

      example '両方にマッチするタスクがない場合、何も得られない' do
        expect(Task.search_with_name("qwerty").search_with_status(4)).to_not include(@task, @new_task, @completed_task)
      end
    end
  end
end

