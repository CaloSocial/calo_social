require 'spec_helper'

describe RelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "creating a relationship with Ajax" do

    it "increments the Relationship count" do
      expect do
        #xhr method to issue an AJAX request
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.to change(Relationship, :count).by(1)
    end

    it "responds with success" do
      xhr :post, :create, relationship: { followed_id: other_user.id }
      expect(response).to be_success
    end
  end

  describe "destroying a relationship with Ajax" do

    before { user.follow!(other_user) }
    let(:relationship) { user.relationships.find_by(followed_id: other_user) }

    it "decrements the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "responds with success" do
      xhr :delete, :destroy, id: relationship.id
      expect(response).to be_success
    end
  end
end
