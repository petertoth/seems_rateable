class CachedRating < ActiveRecord::Base
  attr_accessible :avg, :dimension	
  belongs_to :cacheable, :polymorphic => true 
end
