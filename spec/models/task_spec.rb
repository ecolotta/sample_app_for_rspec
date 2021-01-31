require 'rails_helper'

RSpec.describe Task, type: :model do
  it "タイトルが空欄のときエラーになること" do
    task = FactoryBot.build(:task, title: "")
    expect(task).to_not be_valid
  end

  it "タイトルが重複するときエラーになること" do
    task1 = FactoryBot.create(:task, title: "title1")
    task2 = FactoryBot.build(:task, title: "title1")
    expect(task2).to_not be_valid
  end

  it "ステータスが空欄のときエラーになること" do
    task = FactoryBot.build(:task, status: "")
    expect(task).to_not be_valid
  end
end
