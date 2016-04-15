class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos, force: true do |t|
      t.string :video_id
      t.string :title
      t.string :period
      t.timestamp :published_at
      t.timestamp :tweeted_at
    end

    add_index :videos, %i[video_id]
    add_index :videos, %i[period tweeted_at]
  end
end
