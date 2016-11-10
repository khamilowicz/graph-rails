Rails.application.routes.draw do

  post "/query" => "page#query"

  root to: "page#index"
end
