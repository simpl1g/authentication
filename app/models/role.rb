class Role < ActiveRecord::Base
  belongs_to :user
  attr_accessible :admin, :user_id
end
