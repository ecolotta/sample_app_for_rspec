require 'rails_helper'

RSpec.describe Task, type: :model do
  it "空欄の項目がないとき有効となること" do
    task = build(:task)
    expect(task).to be_valid
    expect(task.errors).to be_empty
  end

  it "タイトルが空欄のときエラーになること" do
    task_without_title = build(:task, title: "")
    expect(task_without_title).to_not be_valid
    expect(task_without_title.errors[:title]).to eq ["can't be blank"]
  end

  it "タイトルが重複するときエラーになること" do
    task = create(:task)
    task_with_duplicated_title = build(:task, title: task.title)
    expect(task_with_duplicated_title).to_not be_valid
    expect(task_with_duplicated_title.errors[:title]).to eq ["has already been taken"]
  end

  it "タイトルが重複しないとき有効であること" do
    task = create(:task)
    task_with_another_title = build(:task, title: "another title")
    expect(task_with_another_title).to be_valid
    expect(task_with_another_title.errors[:title]).to be_empty
  end

  it "ステータスが空欄のときエラーになること" do
    task_without_status = build(:task, status: "")
    expect(task_without_status).to_not be_valid
    expect(task_without_status.errors[:status]).to eq ["can't be blank"]
  end

end
