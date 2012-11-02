include ApplicationHelper

def valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in(user)
  visit signin_path
  valid_signin user
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    if message.nil?
      page.should have_selector 'div.alert.alert-error'
    else
      page.should have_selector 'div.alert.alert-error', text: message
    end
  end
end
