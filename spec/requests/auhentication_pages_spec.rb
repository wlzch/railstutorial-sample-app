require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button 'Sign in' }

      it { should have_selector 'title', text: 'Sign in' }
      it { should have_error_message('Invalid') }
      it { should_not have_link 'Profile' }
      it { should_not have_link 'Settings' }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector 'div.alert.alert-error' }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_selector 'title', text: user.name }
      it { should have_link 'Profile', href: user_path(user) }
      it { should have_link 'Settings', href: edit_user_path(user) }
      it { should have_link 'Users', href: users_path }
      it { should have_link 'Sign out', href: signout_path }
      it { should_not have_link 'Sign in', href: signin_path }
    end

    it { should have_selector 'title', text: 'Sign in' }
    it { should have_selector 'h1', text: 'Sign in' }
  end

  describe "Signing out" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit signin_path
      valid_signin(user)
    end

    describe "clicking the Sign out button" do
        before { click_link 'Sign out' }
        it { should have_link 'Sign in', href: signin_path }
        it { should_not have_link 'Settings' }
    end
  end

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }

    describe "in the Users controller" do
      describe "visiting the edit page" do
        before { visit edit_user_path(user) }
        it { should have_selector 'title', text: 'Sign in' }
      end

      describe "submitting to the update action" do
        before { put user_path(user) }
        specify { response.should redirect_to(signin_path) }
      end
    end

    describe "as wrong user" do
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com') }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector 'title', text: full_title('Edit user') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "for non-signed-in users" do
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          valid_signin user
        end

        describe "after signing in" do
          it { should have_selector 'title', text: 'Edit user' }
        end
      end
    end

    describe "in the users controller" do
      describe "visiting the user index" do
        before { visit users_path }
        it { should have_selector 'title', text: 'Sign in' }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submiting a DELETE request to the Users#destroy" do
        before { delete user_path user }
        specify { response.should redirect_to root_path }
      end
    end

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:another_admin) { FactoryGirl.create(:admin) }

      before { sign_in admin }

      describe "submiting a DELETE request to Users#destroy with admin user" do
        before { delete user_path user }
        specify { response.should redirect_to users_path }
      end
    end

    describe "signed in user" do
      before { sign_in user }

      describe "visitting signup page" do
        before { visit signup_path }
        specify { current_path.should eq root_path }
      end
    end

  end
end
