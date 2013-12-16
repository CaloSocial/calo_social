require 'spec_helper'

describe "Swap pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }



  describe "swap creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "does not create a swap" do
        expect { click_button "Create" }.not_to change(Swap, :count)
      end

      describe "error messages" do
        before { click_button "Create" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'swap_description', with: "Swap Description"
      				 fill_in 'swap_offer', with: "What I offer" 
							 fill_in 'swap_want', with: "What I want"
               fill_in 'swap_tag_list', with: "tango" }

      it "creates a swap" do
        expect { click_button "Create" }.to change(Swap, :count).by(1)
      end
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:s1) { FactoryGirl.create(:swap, user: user, description: "Quiero aprender inglés",
                                    offer: "Canasta de frutos", want: "Clase inglés",
                                    tag_list: "canasta-de-frutos, inglés")}

    before { visit swaps_path(s1) }

    it { should have_title('Swaps') }
    it { should have_content('Swaps') }

    describe "taglist" do
      it { should have_content(s1.tag_list) } 
    end

    describe "swap" do
      it { should have_content(s1.description) }
      it { should have_content(s1.description) }
    end

  end

end
