class Podcast < ApplicationRecord
  has_one :feed, class_name: "feed", foreign_key: "feed_url"
end
