module SeemsRateable
 class ApplicationController < ::ApplicationController
  rescue_from SeemsRateable::Errors::AlreadyRatedError do |exception|
	render :json => {:error => true}
  end
 end
end
