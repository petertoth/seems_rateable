module SeemsRateable
	class CachedRating < ActiveRecord::Base
		belongs_to :cacheable, :polymorphic => true
	end
end
