require 'test_helper'

class CutsControllerTest < ActionDispatch::IntegrationTest
  test "should post new" do
    post cuts_new_path
    assert_response :success
  end

  test "should post delete" do
  end

  test "should get edit" do
    end
  end
end
