require 'spec_helper'

describe 'user model' do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe 'validators' do

    it "should create user with right attrs" do
      expect {
        User.create(login: "simpl", email: "sim@simpl.sim", password: "123", two_step_auth: false)
      }.to change(User, :count).by(1)
    end

    it "should not create user with same login" do
      User.create(login: "sim", email: "sim@simpl.sim", password: "123", two_step_auth: false).should_not
      change(User, :count)
    end

    it "should not create user with same email" do
      User.create(login: "simpl", email: "sim@sim.sim", password: "123", two_step_auth: false).should
      change(User, :count).by(1)
    end
  end

  describe 'authentication' do

    it "should authenticate with correct password" do
      User.authenticate("sim@sim.sim", "123").login.should == @user.login
    end

    it "should not authenticate with wrong password" do
      User.authenticate("sim@sim.sim", "1234").should == nil
    end

    it "shoud find user with email from facebook" do
      User.find_from_facebook({"email" => "sim@sim.sim", "name" => "dsaxcz"}).should == @user
    end

    it "shoud create user with email from facebook" do
      expect{
        User.find_from_facebook({"email" => "simdf@sim.sim", "name" => "dsaxcz"})
      }.to change(User, :count).by(1)
    end

    it "should generate activation code" do
      expect{
        @user.update_activation_code!
      }.to change(Code, :count).by(1)
    end

    it "should get activation code" do
      @user.update_activation_code!
      @user.get_activation_code.should eq @user.codes.last.generated_code
    end

    it "should find user by correct activation code" do
      @user.update_activation_code!
      @user.should eq(User.find_by_activation_code @user.get_activation_code)
    end

    it "should not find user by incorrect activation code" do
      @user.update_activation_code!
      @user.should_not eq(User.find_by_activation_code "dsfsdf")
    end

  end

end