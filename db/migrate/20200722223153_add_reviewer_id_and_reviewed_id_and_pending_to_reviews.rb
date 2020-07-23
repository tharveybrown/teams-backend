class AddReviewerIdAndReviewedIdAndPendingToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :reviewer_id, :integer, :null => true
    add_column :reviews, :reviewed_id, :integer, :null => true
    add_column :reviews, :pending, :boolean
  end
end
