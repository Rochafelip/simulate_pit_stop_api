require "test_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cars_index_url
    assert_response :success
  end

  test "should get show" do
    get cars_show_url
    assert_response :success
  end

  test "should get create" do
    get cars_create_url
    assert_response :success
  end

  test "should get update" do
    get cars_update_url
    assert_response :success
  end

  test "should get destroy" do
    get cars_destroy_url
    assert_response :success
  end
end
