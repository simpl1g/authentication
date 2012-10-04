require 'spec_helper'

describe 'login' do
  before :each do
    @user = FactoryGirl.create(:user, :two_step_auth => true)
    visit login_path
    within(".form-horizontal") do
      fill_in 'Login or Email', :with => 'sim'
      fill_in 'Password', :with => '123'
    end
    click_button 'Submit'
    within(".form-horizontal") do
      fill_in 'Code', :with => @user.get_activation_code
    end
    click_button 'Submit'
  end

  it 'edit profile' do
    visit edit_user_path @user
    page.should have_content('Edit User')
  end

  #it 'deletes profile' do
  #  delete( user_path, @user.id)
  #  page.should have_content('Edit User')
  #end

  #it "should return link without remote if signed in" do
  #  UserHelper.stub(:link_to_user,@user).and_return(:link)
  #  @link.include?("/users/#{@user.id}").should eq true
  #  #UserHelper.stub(:link_to_user,@user).include?("remote").should eq false
  #end
end