require "test_helper"

class HelloControllerTest < ActionDispatch::IntegrationTest
  test "world returns hello world json" do
    get hello_url
    assert_response :success
    assert_equal({ "hello" => "world" }, response.parsed_body)
  end
end
