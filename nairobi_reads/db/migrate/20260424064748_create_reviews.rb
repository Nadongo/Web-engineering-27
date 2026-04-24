class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :comment
      t.references :borrow_request, null: false, foreign_key: true
      t.integer :reviewer_id
      t.integer :reviewee_id

      t.timestamps
    end
  end
end
