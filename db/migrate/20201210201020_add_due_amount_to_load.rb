class AddDueAmountToLoad < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :due_amount, :decimal, precision: 8, scale: 2
  end
end
