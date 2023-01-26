class AddProductDerivationToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :order_items, :product_derivation, foreign_key: true, index: true
  end
end
