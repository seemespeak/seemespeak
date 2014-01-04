require 'test_helper'

class AdminSectionTest < ActionDispatch::IntegrationTest

  def setup
    begin
      Entry.delete_all
    rescue => e
    end
  end

  test "going to admin section should prompt http basic auth." do
  	get '/reviews'
    assert_response 401
  end

  test "going to admin section with valid credentials should grant access" do
    Entry.new(:transcription => "test").index
    sleep 1
  	user = 'admin'
    pw =   'test'
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
  	get("/reviews", nil, {'HTTP_AUTHORIZATION' => auth})
    assert_response 200
  end
end
