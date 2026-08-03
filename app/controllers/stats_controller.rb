class StatsController < ApplicationController
  # GET /stats.json
  def index
    render json: StatsService.call
  end
end
