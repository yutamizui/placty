require "test_helper"

class NoticeBoardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get notice_boards_index_url
    assert_response :success
  end
end
