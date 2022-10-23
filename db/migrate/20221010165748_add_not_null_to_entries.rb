class AddNotNullToEntries < ActiveRecord::Migration[7.0]
  def change
    change_column_null :entries, :price, false
    change_column_null :entries, :name, false
    change_column_null :entries, :date, false
  end
end
