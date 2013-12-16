require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin" do

    before { visit new_user_session_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_registration_path) }
      it { should have_link('Sign out',    href: destroy_user_session_path) }
      it { should_not have_link('Sign in', href: new_user_session_path) }
      
      #shows sign in link after sign out
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should_not have_link('Settings') }
        it { should_not have_link('Profile') }
      end
    end

    describe "authorization" do

      describe "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_registration_path
            fill_in "Login",    with: user.email
            fill_in "Password",  with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do

            it "renders the desired protected page" do
              expect(page).to have_title('Edit user')
            end
          end
        end


        describe "in the Users controller" do

          describe "visiting the edit page" do
            before { visit edit_user_registration_path }
            it { should have_title('Sign in') }
          end

          describe "submitting to the update action" do
            #issues a PATCH request directly to /users/1.
            #there's no way for a browser to visit the update action
            #directly
            before { patch user_path(user) }
            #We test the server response
            specify { expect(response).to redirect_to(new_user_session_path) }
          end          

          describe "visiting the user index" do
            before { visit users_path }
            it { should have_title('Sign in') }
          end

          describe "visiting the following page" do 
            before { visit following_user_path(user) }
            it { should have_title('Sign in') }
          end

          describe "visiting the followers page" do 
            before { visit followers_user_path(user) }
            it { should have_title('Sign in') }
          end
        end

        #Non signed user trying to create and delete micropost
        describe "in the Microposts controller" do

          describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(new_user_session_path) }
          end

          describe "submitting to the destroy action" do
            before { delete micropost_path(FactoryGirl.create(:micropost)) }
            specify { expect(response).to redirect_to(new_user_session_path) }
          end

          describe "in the Relationships controller" do 
            describe "submitting to the create action" do 
              before { post relationships_path }
              specify { expect(response).to redirect_to(new_user_session_path) }
            end

            describe "submitting to the destroy action" do 
              before { delete relationship_path(1) }
              specify  { expect(response).to redirect_to(new_user_session_path) }
            end
          end
        end

        describe "in the Swaps controller" do 

          describe "submitting to the create action" do 
            before { post swaps_path }
            specify { expect(response).to redirect_to(new_user_session_path) }
          end

          describe "submitting to the destroy action" do
            before { delete swap_path(FactoryGirl.create(:swap)) }
            specify { expect(response).to redirect_to(new_user_session_path) }
          end

          describe "submitting to the update action" do 
            before { patch swap_path(FactoryGirl.create(:swap)) }
            specify { expect(response).to redirect_to(new_user_session_path) }
          end
        end
      end

      describe "as wrong user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user }

        describe "submitting a GET request to the Users#edit action" do
          before { get edit_user_path(wrong_user) }
          specify { expect(response.body).not_to match(full_title('Edit user')) }
          specify { expect(response).to redirect_to(new_user_session_path) }
        end

        describe "submitting a PATCH request to the Users#update action" do
          before { patch user_path(wrong_user) }
          specify { expect(response).to redirect_to(new_user_session_path) }
        end
      end

      describe "as non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin }

        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { expect(response).to redirect_to(new_user_session_path) }
        end
      end
    end 
  end
end
