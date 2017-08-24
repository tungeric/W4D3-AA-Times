class CreateArtworkShares < ActiveRecord::Migration[5.1]
  def change
    create_table :artwork_shares do |t|
      t.integer :viewer_id, null: false
      t.integer :artwork_id, null: false
      t.timestamps
    end
    add_index :artwork_shares, [:viewer_id, :artwork_id], unique: true
    add_index :artwork_shares, :artwork_id
  end
end
