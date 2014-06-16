class Post < ActiveRecord::Base
  seems_rateable :speed, :quality, :price
end
