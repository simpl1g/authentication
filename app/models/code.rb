class Code < ActiveRecord::Base
  belongs_to :user
  attr_accessible :generated_code

end
