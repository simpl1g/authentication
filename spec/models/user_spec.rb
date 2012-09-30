require 'spec_helper'

describe 'validators' do
  before(:each) do
    @user = User.create!(login: "sim", email: "sim@sim.sim", password: "123", two_step_auth: false)
  end

  it "should create user with right attrs" do
    User.create!(login: "simpl", email: "sim@simpl.sim", password: "123", two_step_auth: false).should
    change(User, :count).by(2)
  end

  it "should not create user with same login" do
    User.create!(login: "sim", email: "sim@simpl.sim", password: "123", two_step_auth: false).should_not
    change(User, :count)
  end

  it "should not create user with same email" do
    User.create(login: "simpl", email: "sim@sim.sim", password: "123", two_step_auth: false).should
    change(User, :count).by(1)
  end

  it "should create user with right attrs" do
    User.create(login: "simpl", email: "sim@simpl.sim", password: "123", two_step_auth: false).should
    change(User, :count).by(1)
  end

  it "should create user with right attrs" do
    User.create(login: "simpl", email: "sim@simpl.sim", password: "123", two_step_auth: false).should
    change(User, :count).by(1)
  end
end