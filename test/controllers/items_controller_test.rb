require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get items_new_url
    assert_response :success
  end

  test "should get create" do
    get items_create_url
    assert_response :success
  end
end
