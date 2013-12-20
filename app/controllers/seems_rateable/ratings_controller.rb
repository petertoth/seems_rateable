require_dependency "seems_rateable/application_controller"

module SeemsRateable
	class RatingsController < ApplicationController
		def create
			raise NoCurrentUserInstanceError unless current_user
			obj = params[:kls].classify.constantize.find(params[:idBox])
			obj.rate(params[:rate].to_i, current_user.id, params[:dimension])
	
			render :json => true
		end
	end
end
