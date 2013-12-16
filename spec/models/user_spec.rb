require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar123", password_confirmation: "foobar123")
  end

  subject { @user }

  it { should respond_to(:name) }	
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  #Users I follow
  it { should respond_to(:followed_users) }
  #reverse columns so we could implement user.followers with lil' effort
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  #swaps
  it { should respond_to(:swaps) }
  it { should respond_to(:swaps_feed) }

  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      # toggle flip de admint attribute from false to true
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end


  describe "micropost associations" do
    before { @user.save }
    # This uses the let! (read “let bang”) method in place of let; 
    # the reason is that let variables are lazy, meaning that they 
    # only spring into existence when referenced. 
    # The problem is that we want the microposts to exist immediately, 
    # so that the timestamps are in the right order and so 
    # that @user.microposts isn’t empty. 
    # We accomplish this with let!, which forces the corresponding 
    # variable to come into existence immediately.
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "has the right microposts in the right order" do
      #to_a = to array
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "when destroy user, should destroy associated microposts" do 
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do 
      let(:unfollowed_post) do 
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do 
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      #Include checks if an array contains the element given
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do 
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do 
    let(:other_user) { FactoryGirl.create(:user) }
    before do 
      @user.save
      #if follow fails raise an exception (!)
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do 
      #we change subject with subject method, changing user with other_user
      subject { other_user }
      its(:followers) { should include(@user) }
    end 

    describe "and unfollowing" do 
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "swaps" do

    describe "swap associations" do 

      before { @user.save }
      let!(:older_swap) do 
        FactoryGirl.create(:swap, user: @user, created_at: 1.day.ago,
                            place: "Buenos Aires")
      end
      let!(:newer_swap) do 
        FactoryGirl.create(:swap, user: @user, created_at: 1.hour.ago,
                            place: "Buenos Aires")
      end

      it "has the rigth swap in the right order" do 
        expect(@user.swaps.to_a).to eq [newer_swap, older_swap]
      end

      it "destroys associated swaps" do 
        swaps = @user.swaps.to_a
        @user.destroy
        expect(swaps).not_to be_empty
        swaps.each do |swap|
          expect(Swap.where(id: swap.id)).to be_empty
        end
      end


      describe "status" do
        let(:near_swap) do 
            FactoryGirl.create(:swap, user: FactoryGirl.create(:user),
                                      place: "Florida, Buenos Aires")
          end
        let(:distant_swap) do
          FactoryGirl.create(:swap, user: FactoryGirl.create(:user), 
                                    place: "Paris")
        end
        it "check near swaps " do
          

          @user.swaps_feed("24.232.154.67") { should include(near_swap) }
          @user.swaps_feed("24.232.154.67") { should_not include(distant_swap) }

          @user.swaps_feed("24.232.154.67") do
            Swap.near_ip("24.232.154.67") do |swap|
              should include(swap)
            end
          end
        end
      end

    end
  end
end
