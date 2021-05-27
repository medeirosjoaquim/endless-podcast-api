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
    rss_results = []
    puts(data['url'])

    podcast = Podcast.where(url: data['url']).take

    if podcast
      render json: podcast
    else
      render plain: 'no data'
    end

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
    render json: {data: rss_results}
  end
end
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
    rss_results = []
    puts(data['url'])

    podcast = Podcast.where(url: data['url']).take

    if podcast
      render json: {
				title: podcast.title,
        summary: podcast.summary,
        keywords: podcast.keywords,
        category: podcast.category,
				feed: podcast.feed
			}
    else
      #render plain: 'no data'
			begin
				rss = RSS::Parser
						.parse(URI.open(data['url'])
						.read, false)
				feed = rss.items[0..5]
			rescue => e
				puts(e)
				session[:podcast_rss_url] = nil
			else 
				feed.each do |result|
					result = { title: result.title,
						date: result.pubDate,
						link: result.link,
						description: result.description,
						audio_url: result.enclosure.url }
					rss_results.push(result)
				end
				#response = rss_results
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
			}
    end

    
  end
end
