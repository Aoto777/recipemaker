class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.string :title
      t.text :recipe
      t.text :material
      t.text :time
      t.text :comment
      t.string :image

      t.timestamps
    end
  end
end
