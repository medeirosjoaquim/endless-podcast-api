class CreatePodcasts < ActiveRecord::Migration[6.1]
  def change
    create_table :podcasts do |t|
      t.string :title
      t.string :url
      t.jsonb :feed
      t.timestamps
    end
  end
end
