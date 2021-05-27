class CreatePodcasts < ActiveRecord::Migration[6.1]
  def change
    create_table :podcasts do |t|
      t.string :title
      t.string :url
      t.string :category
      t.string :summary
      t.string :keywords, array: true, default: []
      t.jsonb :feed
      t.timestamps
    end
  end
end
