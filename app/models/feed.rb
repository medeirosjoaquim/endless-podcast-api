class Feed < ApplicationRecord
  belongs_to :podcast, class_name: "podcast", foreign_key: "podcast_id"
end
