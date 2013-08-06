module SeemsRateable
 module Errors
  class InvalidRateableObjectError < StandardError
	def to_s
	 "Stated object is not rateable. Add 'seems_rateable' to your object's class model."
	end
  end
		
	class NoCurrentUserInstanceError < StandardError
	 def to_s
	  "User instance current_user is not available."
	 end
	end
		
	class AlreadyRatedError < StandardError
	 def to_s
	  "User has already rated an object."
	 end
	end	
 end
end
