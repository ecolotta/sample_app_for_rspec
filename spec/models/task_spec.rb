require 'rails_helper'

RSpec.describe Task, type: :model do
  it "タイトルが空欄のときエラーになること" do
    task = FactoryBot.build(:task, title: "")
    expect(task).to_not be_valid
    expect(task.errors[:title]).to eq ["can't be blank"]
  end

  it "タイトルが重複するときエラーになること" do
    task1 = FactoryBot.create(:task, title: "title1")
    task2 = FactoryBot.build(:task, title: "title1")
    expect(task2).to_not be_valid
    expect(task2.errors[:title]).to eq ["has already been taken"]
  end

  it "ステータスが空欄のときエラーになること" do
    task = FactoryBot.build(:task, status: "")
    expect(task).to_not be_valid
    expect(task.errors[:status]).to eq ["can't be blank"]
  end
end
