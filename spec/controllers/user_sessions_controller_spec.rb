require 'capybara/rspec'
require 'spec_helper'

describe UserSessionsController do
  render_views

  def two_step_login
    @user = FactoryGirl.create(:user, :two_step_auth => true)
    visit login_path
    within(".form-horizontal") do
      fill_in 'Login or Email', :with => 'sim'
      fill_in 'Password', :with => '123'
    end
    click_button 'Submit'
  end

  it "signs me in without two step" do
    login
    page.should have_content('sim@sim.sim')
  end

  it "flashes error with wrong pass" do
    FactoryGirl.create(:user, :two_step_auth => true)
    visit login_path
    within(".form-horizontal") do
      fill_in 'Login or Email', :with => 'sim'
      fill_in 'Password', :with => '1234'
    end
    click_button 'Submit'
    page.should have_content('Wrong Login, Email or Password')
  end

  describe "login with two step" do
    before :each do
      two_step_login
    end

    it "gives me code with two step" do
      page.should have_content(@user.get_activation_code)
    end

    it "signs in with right code" do
      within(".form-horizontal") do
        fill_in 'Code', :with => @user.get_activation_code
      end
      click_button 'Submit'
      page.should have_content('sim@sim.sim')

    end

    it "signs in with wrong code" do
      within(".form-horizontal") do
        fill_in 'Code', :with => "123321"
      end
      click_button 'Submit'
      page.should_not have_content('sim@sim.sim')
    end

  end

  it "signs out" do
    FactoryGirl.create(:user, :two_step_auth => true)
    visit logout_path
    page.should have_content('LogIn')
  end

end
