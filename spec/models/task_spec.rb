require 'rails_helper'

RSpec.describe 'Tasks', type: :model do
  before do
    @task = build(:task)
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
end

