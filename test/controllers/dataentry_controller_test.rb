require 'test_helper'

class DataentryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dataentry_index_url
    assert_response :success
  end

end
