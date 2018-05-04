require 'test_helper'

class SceneRenderControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get scene_render_show_url
    assert_response :success
  end

end
