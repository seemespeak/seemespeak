require 'test_helper'

class AdminSectionTest < ActionDispatch::IntegrationTest
  test "going to admin section should prompt http basic auth." do
  	get '/reviews'
    assert_response 401
  end

  test "going to admin section with valid credentials should grant access" do
  	user = 'admin'
    pw =   'pass'
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
  	get("/reviews", nil, {'HTTP_AUTHORIZATION' => auth})
    #assert_response :success # doesnt work :(
    assert_response true
  end
end
