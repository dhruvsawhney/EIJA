require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    show user_id_path
    assert_response :success
  end

  #test "should get create" do
    #get user_path
    #assert_response :success
  #end

end
