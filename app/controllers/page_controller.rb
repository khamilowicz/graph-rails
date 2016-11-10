class PageController < ApplicationController

  def index
  end

  def query
    render json: Query.call(request_body, variables: params[:variables])
  end

  def request_body
    request.body.rewind
    request.body.read
  end
end
