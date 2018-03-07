require 'test_helper'

class PlaysControllerTest < ActionDispatch::IntegrationTest
  test "should get first play" do
    assert_equal "My String", @plays['one']['title']
  end

end
