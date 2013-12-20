module SeemsRateable
	module Routes
		def seems_rateable
			mount SeemsRateable::Engine => '/rateable', :as => :rateable
		end
	end
end
