require 'test_helper'

class LineCutsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get line_cuts_new_url
    assert_response :success
  end

  test "should get delete" do
    get line_cuts_delete_url
    assert_response :success
  end

end
