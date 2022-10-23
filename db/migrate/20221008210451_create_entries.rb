class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.decimal :price
      t.string :name
      t.date :date

      t.timestamps
    end
  end
end
