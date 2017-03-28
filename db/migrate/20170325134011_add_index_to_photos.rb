class AddIndexToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_index :photos, :chef_id
  end
end
