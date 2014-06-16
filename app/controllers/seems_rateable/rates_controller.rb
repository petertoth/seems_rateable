require_dependency "application_controller"

module SeemsRateable
  class RatesController < ApplicationController
    before_filter :require_login

    def create
      @rate = Rate.create! rate_params

      render json: { average: rating.average }
    end

    private

    def rateable
      @rate.rateable
    end

    def rating
      rateable.rating(@rate.dimension)
    end

    def rate_params
      params.require(:rate).permit!.merge(rater_id: current_rater.id)
    end

    def require_login
      raise SeemsRateable::Errors::NoCurrentRaterError unless current_rater
    end
  end
end
