module LoginSupport
  def login_as(user)
    visit root_path
    click_link 'Login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Login'
  end

  def sign_in_as(user)
    visit root_path
    click_link 'SignUp'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'SignUp'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
