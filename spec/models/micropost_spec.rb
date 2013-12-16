require 'spec_helper'

describe Micropost do

# 	Using belongs_to/has_many association, rails construct the methods:
# 	Method	Purpose
# micropost.user	Return the User object associated with the micropost.
# user.microposts	Return an array of the user’s microposts.
# user.microposts.create(arg)	Create a micropost (user_id = user.id).
# user.microposts.create!(arg)	Create a micropost (exception on failure).
# user.microposts.build(arg)	Return a new Micropost object (user_id = user.id).
 	
 	let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do 
  	before { @micropost.content = " " }
  	it { should_not be_valid }
  end

  describe "with content that is too long" do
  	before { @micropost.content = "a" * 141 }
  	it { should_not be_valid }
  end
end
