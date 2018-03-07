require 'test_helper'

class EditPlaysControllerTest < ActionDispatch::IntegrationTest
  test correct play name do
    assert_equal "My String", @editplays['one']['play']
    end
=begin
  test "should get index" do
    get edit_plays_url
    assert_response :success
  end

  test "should get new" do
    get new_edit_play_url
    assert_response :success
  end

  test "should create edit_play" do
    assert_difference('EditPlay.count') do
      post edit_plays_url, params: { edit_play: { play: @edit_play.play } }
    end

    assert_redirected_to edit_play_url(EditPlay.last)
  end

  test "should show edit_play" do
    get edit_play_url(@edit_play)
    assert_response :success
  end

  test "should get edit" do
    get edit_edit_play_url(@edit_play)
    assert_response :success
  end

  test "should update edit_play" do
    patch edit_play_url(@edit_play), params: { edit_play: { play: @edit_play.play } }
    assert_redirected_to edit_play_url(@edit_play)
  end

  test "should destroy edit_play" do
    assert_difference('EditPlay.count', -1) do
      delete edit_play_url(@edit_play)
    end

    assert_redirected_to edit_plays_url
  end
=end
end
