require 'spec_helper'

describe UsersController do
  render_views

  describe "POST create" do
    it "creates user with wright params" do
      post(:create, :user => { :login => "123", :password => "123", :email => "123@123.ru" })
      User.find_by_login("123").login.should eq "123"
    end

    it "not creates user with wright params" do
      post(:create, :user => { :login => "123", :password => "123", :email => "123.ru" })
      User.find_by_login("123").should eq nil
    end
  end

  describe "PUT update" do
    #it "updates user with wright params" do
    #  @user = FactoryGirl.create :user
    #  put(:update, :id => @user.id, :user => { :login => "123", :password => "123", :email => "123@123.ru" })
    #  User.find_by_login("123").login.should eq "123"
    #end

    it "not updates user with wright params" do
      post(:create, :user => { :login => "123", :password => "123", :email => "123.ru" })
      User.find_by_login("123").should eq nil
    end

    it "changes @user's attributes" do
      @user = FactoryGirl.create(:user, login: "Lawrence", email: "Smith@fgd.ru")
      put :update, id: @user.id, user: { :login => "123", :password => "123", :email => "123@123.ru" }
      @user.reload
      @user.login.should eq("123")
      @user.email.should eq("123@123.ru")
    end
  end

end