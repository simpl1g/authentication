require 'capybara/rspec'
require 'spec_helper'

describe "the login process", :type => :request do
  #before :each do
  #  User.create(:email => 'user@example.com', :password => 'caplin', :login => 'user', :two_step_auth => false)
  #end

  it "signs me in without two step" do
    Role.create
    User.create(:email => 'user@example.com', :password => 'caplin', :login => 'user', :two_step_auth => false)
    visit("/login")
    within(".form-horizontal") do
      fill_in 'Login or Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'caplin'
    end
    click_button 'Submit'
    expect(page).to have_selector("dd", :text => "user")
  end

  it "gives me code with two step" do
    Role.create
    User.create(:email => 'user@example.com', :password => 'caplin', :login => 'user', :two_step_auth => true)
    visit("/login")
    within(".form-horizontal") do
      fill_in 'Login or Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'caplin'
    end
    click_button 'Submit'
    expect(page).to have_selector("label.control-label", :text => "Code")
  end

  it "makes first user admin" do
    Role.create(:admin => true)
    user = User.create(:email => 'user@example.com', :password => 'caplin', :login => 'user', :two_step_auth => false)
    expect(user.role.admin).to eq(true)
  end

end