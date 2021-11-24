Rails.application.routes.draw do
  match '/' => 'podcasts#index', via: :get
  match '/' => 'podcasts#fetch_rss', via: :post
  match '/list' => 'podcasts#list', via: :get
  match 'test' => 'podcasts#test', via: :post
end
