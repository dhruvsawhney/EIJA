require 'test_helper'

class CutsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get cut_delete
    assert_response :success
  end

end
