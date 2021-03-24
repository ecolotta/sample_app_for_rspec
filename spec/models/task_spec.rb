require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do      
      task_with_all_attributes = build(:task)
      expect(task_with_all_attributes).to be_valid
    end
    it 'is invalid without title' do
      task_without_title = build(:task, title: "")
      expect(task_without_title).to_not be_valid
    end
    it 'is invalid without status' do
      task_without_status = build(:task, status:"")
      expect(task_without_status).to_not be_valid
    end
    it 'is invalid with a duplicate title' do
      task = create(:task)
      task_with_duplicate_title = build(:task, title: task.title)
      expect(task_with_duplicate_title).to_not be_valid
    end
    it 'is valid with another title' do
      task = create(:task, title: "test")
      task_with_another_title = build(:task, title: "another")
      expect(task_with_another_title).to be_valid
    end
  end
end

