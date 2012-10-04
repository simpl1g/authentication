FactoryGirl.define do
  factory :user, class:User do |u|
    u.login "sim"
    u.email  "sim@sim.sim"
    u.two_step_auth false
    u.password "123"
  end
end