require 'test_helper'

module SeemsRateable
  class RatingsControllerTest < ActionController::TestCase
    test "should get create" do
      get :create
      assert_response :success
    end

  end
end
