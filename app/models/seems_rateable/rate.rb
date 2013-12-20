module SeemsRateable
  class Rate < ActiveRecord::Base
    belongs_to :rater, :class_name => SeemsRateable::Engine.config.owner_class
    belongs_to :rateable, :polymorphic => true
  end
end
