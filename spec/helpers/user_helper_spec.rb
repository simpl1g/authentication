require 'spec_helper'

describe "UserHelper" do
  describe "#link_to_gravatar" do
    it "has correct return value" do
      helper.link_to_gravatar("1@2.ru", 200).should match /http:\/\/www.gravatar.com\/avatar\/[a-z0-9]+\?d=wavatar&s=200/
    end
  end

  describe "#link_to_user" do
    it "should return link with remote if not signed in" do
      @user = FactoryGirl.create(:user)
      helper.link_to_user(@user).include?("/users/#{@user.id}").should eq true
      helper.link_to_user(@user).include?("remote").should eq true
    end
  end
end