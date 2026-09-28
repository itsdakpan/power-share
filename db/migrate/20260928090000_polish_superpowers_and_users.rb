class PolishSuperpowersAndUsers < ActiveRecord::Migration[8.1]
  def change
    change_column :superpowers, :price, :decimal, precision: 8, scale: 2
    add_column :users, :first_name, :string
  end
end
