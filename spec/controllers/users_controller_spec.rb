require 'capybara/rspec'
require 'spec_helper'

describe UsersController do
  render_views

  describe "GET new" do
    it "assigns new user" do
      visit new_user_path
      page.should have_content("New User")
    end
  end

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

  #describe "PUT update" do
  #  #it "updates user with wright params" do
  #  #  @user = FactoryGirl.create :user
  #  #  put(:update, :id => @user.id, :user => { :login => "123", :password => "123", :email => "123@123.ru" })
  #  #  User.find_by_login("123").login.should eq "123"
  #  #end
  #
  #  it "not updates user with wright params" do
  #    post(:create, :user => { :login => "123", :password => "123", :email => "123.ru" })
  #    User.find_by_login("123").should eq nil
  #  end
  #
  #  it "changes @user's attributes" do
  #    @user = FactoryGirl.create(:user, login: "Lawrence", email: "Smith@fgd.ru")
  #    put :update, id: @user.id, user: { :login => "123", :password => "123", :email => "123@123.ru" }
  #    @user.reload
  #    @user.login.should eq("123")
  #    @user.email.should eq("123@123.ru")
  #  end
  #end
  #

  #describe 'DELETE destroy' do
  #  before :each do
  #    @user = FactoryGirl.create(:user, :two_step_auth => true)
  #    visit login_path
  #    within(".form-horizontal") do
  #      fill_in 'Login or Email', :with => 'sim'
  #      fill_in 'Password', :with => '123'
  #    end
  #    click_button 'Submit'
  #    within(".form-horizontal") do
  #      fill_in 'Code', :with => @user.get_activation_code
  #    end
  #    click_button 'Submit'
  #  end
  #
  #  it "deletes the user" do
  #    expect{
  #      delete :destroy, id: 1
  #    }.to change(User, :count).by(-1)
  #  end
  #
  #  it "redirects to users#index" do
  #    delete :destroy, id: @user
  #    response.should redirect_to users_url
  #  end
  #end
end