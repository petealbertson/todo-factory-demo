class DashboardController < ApplicationController
  # GET /dashboard
  def index
    @todos = Todo.ordered.includes(:tags)
    stats = StatsService.call
    @total = stats[:total]
    @completed = stats[:completed]
    @overdue = stats[:overdue]
  end
end
