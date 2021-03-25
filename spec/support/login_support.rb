module LoginSupport
  def login(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button { 'login' }
  end

  def sign_in_as(user)
    visit sign_up_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'SignUp'
  end
end