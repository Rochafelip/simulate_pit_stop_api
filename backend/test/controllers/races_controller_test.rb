require "test_helper"

class RacesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get races_index_url
    assert_response :success
  end

  test "should get show" do
    get races_show_url
    assert_response :success
  end

  test "should get create" do
    get races_create_url
    assert_response :success
  end

  test "should get update" do
    get races_update_url
    assert_response :success
  end

  test "should get destroy" do
    get races_destroy_url
    assert_response :success
  end
end
