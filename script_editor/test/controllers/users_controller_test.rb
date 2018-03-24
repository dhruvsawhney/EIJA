require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get first user" do
    assert_equal "id", @user['one']['id']
  end
  test "should get show" do
    show user_path
    assert_response :success
  end

  #test "should get create" do
    #get user_path
    #assert_response :success
  #end

end
