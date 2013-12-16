require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do 
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "lists each user" do 
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    # describe "delete links" do

    #   it { should_not have_link('delete') }

    #   describe "as an admin user" do
    #     let(:admin) { FactoryGirl.create(:admin) }
    #     before do
    #       sign_in admin
    #       visit users_path
    #     end

    #     it { should have_link('delete', href: user_path(User.first)) }
    #     it "is able to delete another user" do
    #       expect do
    #         click_link('delete', match: :first)
    #       end.to change(User, :count).by(-1)
    #     end
    #     it { should_not have_link('delete', href: user_path(admin)) }
    #   end
    # end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
    let!(:s1) { FactoryGirl.create(:swap, user: user, description: "Busco intercambio",
                                    offer: "tabla de surf", want: "intercambio", 
                                    tag_list: "intercambio, surf")}
    let!(:s2) { FactoryGirl.create(:swap, user: user, description: "Quiero aprender inglés",
                                    offer: "Canasta de frutos", want: "Clase inglés",
                                    tag_list: "canasta-de-frutos, inglés")}


    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
    
    describe "micropost" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "swap" do
      it { should have_content(s1.description) }
      it { should have_content(s2.description) }
      it { should have_content(user.swaps.count) }
    end

    describe "follow/unfollow buttons" do 
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do 
        before { visit user_path(other_user) }

        it "increments the followed user count" do 
          expect do 
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do 
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do 
        before do 
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "decrements the followed user count" do 
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "decrements the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
  end

  # Signup Tests:
  describe "signup" do
  	
    before { visit new_user_registration_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
    # User shouldn't create account without filling the form:
      it "does not create a user" do
        expect { click_button submit }.not_to change(User, :count)
	  end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    # Click create account with form filled
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar123"
        fill_in "Password confirmation", with: "foobar123"
      end

      it "creates a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      #Search for the user and test if flash message appears:
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        before { visit user_path(user)}
        it { should have_title(user.name) }

      end      
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_registration_path 
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Password",         with: user.password
        fill_in "Password confirmation", with: user.password
        fill_in "Current password", with: user.password
        click_button "Update"
      end

      before { visit user_path(user)}

      it { should have_title(new_name) }
      it { should have_link('Sign out', href: destroy_user_session_path) }
      specify { expect(user.reload.name).to  eq new_name }
    end


    describe "with invalid information" do
      before { click_button "Update" }

      it { should have_content('error') }
    end

  end

  describe "following/followers" do 
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do 
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do 
      before do 
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
