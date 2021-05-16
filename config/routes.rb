Rails.application.routes.draw do
  match '/' => 'podcasts#index', via: :get
  match '/' => 'podcasts#fetch_rss', via: :post
end
