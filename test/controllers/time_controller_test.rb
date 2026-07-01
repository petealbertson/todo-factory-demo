require "test_helper"

class TimeControllerTest < ActionDispatch::IntegrationTest
  test "index returns current time as iso8601 json" do
    freeze_time do
      get time_url
      assert_response :success
      assert_equal({ "time" => Time.current.iso8601 }, response.parsed_body)
    end
  end
end
