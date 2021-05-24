class CreateFeeds < ActiveRecord::Migration[6.1]
  def change
    create_table :feeds do |t|
      url: string
      t.jsonb :feed
      
      t.timestamps
    end
  end
end
