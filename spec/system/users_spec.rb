require 'rails_helper'

RSpec.describe "Users", type: :system do
  
  describe 'ログイン前' do
    describe 'サインアップ' do
      context 'サインアップフォームの入力に問題がない' do
        it 'ユーザーが作成できる' do
          user = build(:user)
          sign_in_as(user)
          expect(current_path).to eq login_path
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力時' do
        it 'ユーザー作成できない' do
          user = build(:user, email:"")
          sign_in_as(user)
          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済メールアドレス使用時' do
        it 'ユーザー作成できない' do
          user_with_sameemail = create(:user)
          visit sign_up_path
          fill_in 'Email', with: user_with_sameemail.email
          fill_in 'Password', with: "password"
          fill_in 'Password confirmation', with: "password"
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content "has already been taken"
        end
      end
    end
    describe '画面遷移' do
      let!(:user){ create :user }
      context 'ログインしていないユーザーで作成ページにアクセスする' do
        it '遷移できない' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
      context 'ログインしていないユーザーで編集ページにアクセスする' do
        it '遷移できない' do
          task = create(:task, user: user)
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
      context 'ログインしていないユーザーでマイページにアクセスする' do
        it '遷移できない' do
          visit user_path(user)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    let!(:user){ create :user }
    before { login(user) }
    describe '画面遷移' do
      let(:another_user){ create :user }
      let(:another_task){ create :task, user: another_user }
      context '他のユーザーのユーザー編集にアクセスする' do
        it '遷移できない' do
          visit edit_user_path(another_user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(user)
        end
      end
      context '他のユーザーのタスク編集にアクセスする' do
        it '遷移できない' do
          visit edit_task_path(another_task)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq root_path
        end
      end
    end
  end
end
# ・ログインしていないユーザーでタスクの新規作成、編集、マイページへの遷移ができないこと
# ・他のユーザーのユーザー編集、タスク編集ページへの遷移ができないこと
# ・ユーザーの新規作成、編集ができること
# ・メールアドレスが未入力時にユーザーの新規作成、編集が失敗すること
# ・登録済メールアドレス使用時にユーザーの新規作成、編集が失敗すること
# ・ログインが成功すること
# ・フォーム未入力時にログインが失敗すること