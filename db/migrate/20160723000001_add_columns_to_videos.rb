class AddColumnsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :unavailable, :boolean, default: false, null: false
    add_column :videos, :tweeted, :boolean, default: false, null: false

    remove_index :videos, %i(period tweeted_at)
    add_index :videos, %i(unavailable period tweeted)
  end
end
