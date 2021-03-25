require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user){ create :user }
  describe 'タスクの作成・編集・削除' do
    describe 'ログイン後' do
      before do
        login(user)
      end
      describe 'タスク作成' do
        context 'フォームの入力値が正常' do
          it 'タスクの新規作成が成功する' do
            visit new_task_path
            fill_in 'Title', with: 'TestTitle'
            fill_in 'Content', with: 'TestContent'
            click_button { 'Create Task' }
            expect(page).to have_content "Test"
            expect(page).to have_content 'Task was successfully created.'
          end
        end
        context 'マイページの表示' do
          it 'ユーザーが新規作成したタスクが表示されること' do
            visit new_task_path
            task = create(:task)
            click_link 'Mypage'
            expect(current_path).to eq user_path(user)
            expect(page).to have_content "#{task.title}"
            expect(page).to have_content "#{task.content}"
          end
        end
      end
      describe 'タスク編集' do
        let(:task){ create :task, user: user }
        context 'フォームの入力値が正常' do
          it 'タスクの編集が成功する' do
            visit edit_task_path(task.id)
            fill_in 'Title', with: 'TestTitleUpdate'
            fill_in 'Content', with: 'TestContentUpdate'
            click_button { 'Update Task' }
            expect(page).to have_content "TestTitleUpdate"
            expect(page).to have_content 'Task was successfully updated.'
          end
        end
      end
      describe 'タスク削除' do
        context 'タスクの削除' do
          it 'タスクの削除が成功する' do
            task = create(:task, user: user)
            visit tasks_path
            page.accept_confirm 'Are you sure?' do
              click_link 'Destroy'
            end
            expect(page).to_not have_content "#{task.title}"
            expect(page).to have_content "Task was successfully destroyed."
          end
        end
      end
    end
  end
end
# ・ログインした状態でタスクの新規作成、編集、削除ができること
# ・マイページにユーザーが新規作成したタスクが表示されること
# ・ログインしていないユーザーでタスクの新規作成、編集、マイページへの遷移ができないこと
# ・他のユーザーのユーザー編集、タスク編集ページへの遷移ができないこと