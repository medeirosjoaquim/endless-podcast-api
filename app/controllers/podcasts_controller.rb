class PodcastsController < ApplicationController

	require "rss"
	require "open-uri"

	skip_before_action :verify_authenticity_token, :only => [:index, :fetch_rss]
	
	def index
		render plain: 'Hello, World!'
	end
	
	def fetch_rss
		url = session[:podcast_rss_url]
		data = JSON.parse(request.body.read)
		data['url']
		Rails.cache.fetch("podcast_#{data['url']}")
		podcast = Podcast.where(url: data['url']).take
		if podcast
			render json: podcast
		else 

		rss_results = []
		puts(data['url'])
				begin
			@rss = RSS::Parser
          .parse(URI.open(data['url'])
          .read, false).items[0..5]
		rescue => e
			puts(e)
			session[:podcast_rss_url] = nil
		else 
			@rss.each do |result|
				result = { title: result.title,
					date: result.pubDate,
					link: result.link,
					description: result.description,
				  audio_url: result.enclosure.url }
				rss_results.push(result)
			end
			response = rss_results
			puts (@rss)
		end
		Rails.cache.write("podcast_#{data['url']}", rss_results)
		render json: rss_results
	end
end
