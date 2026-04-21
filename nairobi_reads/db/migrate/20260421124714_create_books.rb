class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.text :description, null: false
      t.integer :status, null: false, default: 0
      
      # Setting up the foreign keys
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
