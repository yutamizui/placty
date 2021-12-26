require "test_helper"

class TicketsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get tickets_create_url
    assert_response :success
  end
end
