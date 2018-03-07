require 'test_helper'

class CutsControllerTest < ActionDispatch::IntegrationTest
  test "should post new" do
    post cuts_new_path
    assert_response :success
  end

  test "should post delete" do
    post cuts_delete_path
    assert_response :success
  end

end
