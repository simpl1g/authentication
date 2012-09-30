require 'spec_helper'

describe 'user model' do
  before(:each) do
    @user = User.create!(login: "sim", email: "sim@sim.sim", password: "123", two_step_auth: false)
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
      User.authenticate("sim@sim.sim", "1234").should == false
    end

  end

end