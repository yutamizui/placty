require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get customer_registration" do
    get payments_customer_registration_url
    assert_response :success
  end
end
