require 'rails_helper'

RSpec.describe "Tasks", type: :system, js: true do
  let(:user) { create(:user) }
  describe 'ログイン前' do
    context 'ログインが必要なページにアクセスする' do
      it '新規作成ページにアクセスできない' do
        visit new_task_path
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login required'
      end
      it '編集ページにアクセスできない' do
        visit edit_task_path(user)
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login required'
      end
      it 'マイページにアクセスできない' do
        visit user_path(user)
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login required'
      end
    end
  end
  describe 'タスクの新規作成' do
    context 'ログイン後' do
      it 'タスクの新規作成ができる' do
        login_as user
        visit new_task_path
        fill_in 'Title', with: 'Task1'
        fill_in 'Content', with: 'Content1'
        select 'todo', from: 'task[status]'
        fill_in 'Deadline', with: Time.now
        click_button 'Create Task'
        expect(page).to have_content 'Task1'
        expect(page).to have_content 'Content1'
      end
      it 'タスクの編集ができる' do
        login_as user
        task = create(:task, user: user)
        visit edit_task_path(task)
        fill_in 'Title', with: 'change title'
        fill_in 'Content', with: 'change content'
        click_button 'Update Task'
        expect(current_path).to eq task_path(task)
        expect(page).to have_content 'Task was successfully updated.'
      end
      it 'タスクの削除ができる' do
        login_as user
        task = create(:task, user: user)
        visit tasks_path
        page.accept_confirm 'Are you sure?' do
          click_link 'Destroy'
        end
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'Task was successfully destroyed.'
      end
    end
  end
end
