class CreateBorrowRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :borrow_requests do |t|
      # We added { to_table: :users } so Rails knows where to look!
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :book, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end