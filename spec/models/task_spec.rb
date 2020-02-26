require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    @task = build(:task)
  end

  describe 'taskのバリデーション' do
    it 'nameとcontentどちらも空文字ではなければOK' do
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
  end
end
