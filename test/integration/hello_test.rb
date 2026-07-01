require "test_helper"

class HelloTest < ActionDispatch::IntegrationTest
  test "GET /hello returns JSON hello world" do
    get hello_url

    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
    assert_equal({ "hello" => "world" }, JSON.parse(response.body))
  end
end
