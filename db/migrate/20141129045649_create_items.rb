class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :code, unique: true, null: false
      t.string :name, null: false
      t.integer :category_id

      t.timestamps
    end
    add_index :items, :code
  end
end
