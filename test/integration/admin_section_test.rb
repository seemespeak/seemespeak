require 'test_helper'

class AdminSectionTest < ActionDispatch::IntegrationTest
  test "going to admin section should prompt http basic." do
  	get '/reviews'
    assert_response 401
  end

  test "going to admin section with valid credentials should grant access" do
  	user = 'admin'
    pw = 'test'
    #@request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin:test")
    #request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  	get '/reviews'
    assert_response :success 
  end
end
