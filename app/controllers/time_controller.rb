class TimeController < ApplicationController
  def index
    render json: { time: Time.current.iso8601 }
  end
end
