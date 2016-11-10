class PageController < ApplicationController

  def index
  end

  def query
    render json: Query.call(request_body)
  end

  def request_body
    request.body.rewind
    request.body.read
  end
end
