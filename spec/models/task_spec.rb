require 'rails_helper'

RSpec.describe 'Tasks', type: :model do
  before do
    @task = build(:task)
    @new_task = build(:new_task)
    @completed_task = build(:completed_task)
  end

  describe 'taskのバリデーション' do
    it 'name,content,deadlineがどれも空文字ではなければOK' do
      expect(@task.valid?).to eq(true)
    end

    it 'nameが空だとNG' do
      @task.name = ''
      expect(@task.valid?).to eq(false)
    end

    it 'contentが空だとNG' do
      @task.content = ''
      expect(@task.valid?).to eq(false)
    end

    it 'deadlineが空だとNG' do
      @task.deadline = ''
      expect(@task.valid?).to eq(false)
    end

  end

  describe '検索のテスト' do
    before do
      @new_task = create(:new_task)
      @task = create(:task)
      @completed_task = create(:completed_task)
    end
    
    describe 'タスク名のみの検索' do
      it '検索したタスク名が入っている' do
        expect(Task.search_with_name("new_test_task")).to include(@new_task)
      end

      it 'タスク名にマッチしない場合はNG' do
        expect(Task.search_with_name("no_match")).to_not include(@new_task, @task, @completed_task)
      end
    end

    describe 'ステータスのみの検索' do
      it '検索したステータスのみ表示される' do
        expect(Task.search_with_status("着手")).to include(@new_task)
      end

      it 'ステータス名にマッチしない場合はNG' do
        expect(Task.search_with_status("着手")).to_not include(@task, @completed_task)
      end
    end

    describe 'タスク名とステータス名両方での検索' do
      it 'どちらの検索条件にも引っかかるタスクがマッチする' do
        expect(Task.search_with_name("new_test_task").search_with_status("着手")).to include(@new_task)
      end

      it 'タスク名のみマッチしてもステータスがマッチしなければ検索結果は得られない' do
        expect(Task.search_with_name("new_test_task").search_with_status("未着手")).to_not include(@new_task)
      end

      it 'ステータスのみマッチしてもタスク名がマッチしなければ検索結果は得られない' do
        expect(Task.search_with_name("qwerty").search_with_status("着手")).to_not include(@new_task)
      end

      it '両方にマッチするタスクがない場合、何も得られない' do
        expect(Task.search_with_name("qwerty").search_with_status("qwerty")).to_not include(@task, @new_task, @completed_task)
      end
    end
  end
end

