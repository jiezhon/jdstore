class AddFriendlyId < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :friendly_id, :string
    add_index :chefs, :friendly_id, :unique => true

    add_column :products, :friendly_id, :string
    add_index :products, :friendly_id, :unique => true

    Chef.find_each do |c|
      c.update( :friendly_id => SecureRandom.uuid )
    end

    Product.find_each do |d|
      d.update( :friendly_id => SecureRandom.uuid )
    end
  end
end
