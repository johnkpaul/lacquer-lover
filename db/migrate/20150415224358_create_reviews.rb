class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :comments
      t.integer :lacquer_id
      t.integer :user_id
      t.timestamps
    end
  end
end
