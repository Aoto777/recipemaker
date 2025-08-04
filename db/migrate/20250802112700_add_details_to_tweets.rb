class AddDetailsToTweets < ActiveRecord::Migration[7.1]
  def change
    add_column :tweets, :overall, :integer
    add_column :tweets, :level, :integer
  end
end
