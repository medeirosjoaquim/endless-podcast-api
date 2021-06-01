class PodcastsController < ApplicationController

  require "rss"
  require "open-uri"

  skip_before_action :verify_authenticity_token, :only => [:index, :fetch_rss]
  
  def index
    render plain: 'Hello, World!'
  end
  
  def fetch_rss
    data = JSON.parse(request.body.read)
    rss_results = []
    url = data['url']
    url.prepend "https://" unless url.start_with?('http://', 'https://')

    podcast = Podcast.where(url: url).take

    if podcast
      render json: {
				title: podcast.title,
        summary: podcast.summary,
        keywords: podcast.keywords,
        category: podcast.category,
				feed: podcast.feed
			}
    else
			begin
				rss = RSS::Parser
						.parse(URI.open(url)
						.read, false)
        
				feed = rss.items
			rescue => e
				puts(e)
				render plain: 'Not Found', :status => '404' and return
			else 
				
				feed.each do |result|
					result = { title: result.title,
						date: result.pubDate,
						link: result.link,
						description: result.description,
						audio_url: result.enclosure.url }
					rss_results.push(result)
				end
					title = rss.channel.title
					summary = rss.channel.itunes_summary
					keywords = rss.channel.itunes_keywords
					category = rss.channel.itunes_category.text
					Podcast.new(title: title, 
					summary: summary,
					url: data['url'], 
					category: category, 
					keywords: keywords,
					feed: rss_results
					).save
					
					render json: {
						title: title,
						summary: summary,
						keywords: keywords,
						category: category,
						feed: rss_results
					} and return
				end
			end
    end
  end
