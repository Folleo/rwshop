class AddColumnImgToProduct < ActiveRecord::Migration
  def change
    add_column :products, :image, :string
  end
end
