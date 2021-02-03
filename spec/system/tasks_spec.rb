require 'rails_helper'

RSpec.describe "Tasks", type: :system, js: true do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context '新規作成ページにアクセスする' do
        it '新規作成ページにアクセスできない' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
      context '編集ページにアクセスする' do
        it '編集ページにアクセスできない' do
          visit edit_task_path(user)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
      context 'マイページにアクセスする' do
        it 'マイページにアクセスできない' do
          visit user_path(user)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
      context 'タスクの一覧ページにアクセス' do
        it 'すべてのユーザーのタスク情報が表示される' do
          task_list = create_list(:task, 3)
          visit tasks_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).to have_content task_list[2].title
          expect(current_path).to eq tasks_path
        end
      end
    end
  end
  describe 'ログイン後' do
    before { login_as(user) }

    describe 'タスク新規登録' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成ができる' do
          visit new_task_path
          fill_in 'Title', with: 'Task1'
          fill_in 'Content', with: 'Content1'
          select 'todo', from: 'task[status]'
          fill_in 'Deadline', with: Time.now
          click_button 'Create Task'
          expect(page).to have_content 'Task1'
          expect(page).to have_content 'Content1'
          expect(current_path).to eq '/tasks/1'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'Content1'
          select 'todo', from: 'task[status]'
          fill_in 'Deadline', with: Time.now
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          task_with_duplicate_title = create(:task)
          fill_in 'Title', with: task_with_duplicate_title.title
          fill_in 'Content', with: 'Content1'
          select 'todo', from: 'task[status]'
          fill_in 'Deadline', with: Time.now
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq tasks_path
        end
      end
    end
      
    describe 'タスク編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      before { visit edit_task_path(task) }

      context 'フォームの入力が正常' do
        it 'タスクの編集ができる' do
          fill_in 'Title', with: 'change title'
          fill_in 'Content', with: 'change content'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content 'Task was successfully updated.'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'change content'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスクの削除ができる' do
      it 'タスクの削除ができる' do
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
