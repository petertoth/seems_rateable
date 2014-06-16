class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable

  seems_rateable_rater
end
