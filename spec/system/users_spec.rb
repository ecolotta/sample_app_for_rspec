require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          user = build(:user)
          sign_in_as user
          expect(current_path).to eq login_path
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          user_without_email = build(:user, email: "")
          sign_in_as user_without_email
          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          user = create(:user)
          user_with_duplicated_email = build(:user, email: user.email)
          sign_in_as user_with_duplicated_email
          expect(current_path).to eq users_path
          expect(page).to have_content 'Email has already been taken'
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          user = create(:user)
          visit user_path(user)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
    end
  end

  describe 'ログイン後' do
    let(:user) { create(:user) }
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          login_as(user)
          visit edit_user_path(user)
          fill_in 'Email', with: user.email
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'User was successfully updated.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          login_as(user)
          visit edit_user_path(user)
          fill_in 'Email', with:''
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          user_with_duplicated_email = create(:user)
          login_as(user)
          visit edit_user_path(user)
          fill_in 'Email', with: user_with_duplicated_email.email
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email has already been taken"
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          another_user = create(:user)
          login_as(user)
          visit edit_user_path(another_user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Forbidden access"
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          login_as(user)
          task = create(:task, user: user)
          visit user_path(user)
          expect(page).to have_content "#{task.title}"
          expect(page).to have_content "#{task.status}"
        end
      end
    end
  end
end
