require 'test_helper'

class CutsControllerTest < ActionDispatch::IntegrationTest
<<<<<<< HEAD
  test "should post new" do
    post cuts_new_path
    assert_response :success
  end

  test "should post delete" do
    post cuts_delete_path
=======
  test "should get edit" do
    get cut_delete
>>>>>>> develop-dhruv2
    assert_response :success
  end

end
