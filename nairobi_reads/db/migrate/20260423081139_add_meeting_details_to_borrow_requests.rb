class AddMeetingDetailsToBorrowRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :borrow_requests, :proposed_datetime, :datetime
    add_column :borrow_requests, :message, :text
  end
end
