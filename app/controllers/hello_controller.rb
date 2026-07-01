class HelloController < ApplicationController
  def world
    render json: { hello: "world" }
  end
end
