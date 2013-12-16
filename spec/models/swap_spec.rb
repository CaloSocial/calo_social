require 'spec_helper'

describe Swap do

  let(:user) { FactoryGirl.create(:user) }
  before { @swap = user.swaps.build(description: "Ofrezco una buena trabla de surf",
    	offer: "Tabla de Surf", want: "Clases de piano", place: "Buenos Aires",
              tag_list: "piano, tabla-de-surf") }

  subject { @swap }

  it { should respond_to(:user_id) }
  it { should respond_to(:description) }
  it { should respond_to(:offer) }
  it { should respond_to(:want) }
  it { should respond_to(:place) }
  it { should respond_to(:tag_list) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do 
  	before { @swap.user_id = nil }
  	it { should_not be_valid }
  end

  describe "description" do 

	  describe "is blank" do 
	  	before { @swap.description = " " }
	  	it { should_not be_valid }
	  end

	  describe "is too long" do 
	  	before { @swap.description = "a"*141 }
	  	it { should_not be_valid }
	  end
	end

  describe "blank fields behaviour: " do

    describe "offer should not be valid" do 
    	before { @swap.offer = " " }
    	it { should_not be_valid }
    end

    describe "want should be valid" do 
    	before { @swap.want= " " }
    	it { should be_valid }
    end

    describe "place should be valid" do 
      before { @swap.place = " " }
      it { should be_valid }
    end
    
    describe "tag_list should_not be valid" do 
      before { @swap.tag_list = " " }
      it { should_not be_valid }
    end
  end



  describe "tag_list" do
    describe "when format is invalid" do
      it "is invalid" do
        #%w is a shortcut for an array %w[hola como estas] = ["hola", "como", "estas"]
        tag_list = ["collar de rro"]
        tag_list.each do |invalid_tag|
          @swap.tag_list = invalid_tag
          expect(@swap).not_to be_valid
        end
      end 
    end

    describe "when format is valid" do
      it "is valid" do
        #%w is a shortcut for an array %w[hola como estas] = ["hola", "como", "estas"]
        tag_list = ["collar, de, rro",  "gato", "pardo",
                       "carlit,osasds"]
        tag_list.each do |valid_tag|
          @swap.tag_list = valid_tag
          expect(@swap).to be_valid
        end
      end
    end 
  end
end
