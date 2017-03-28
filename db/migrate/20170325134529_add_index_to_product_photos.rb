class AddIndexToProductPhotos < ActiveRecord::Migration[5.0]
  def change
    add_index :product_photos, :product_id
  end
end
