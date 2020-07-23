class AddRatingAndSkillToReview < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :rating, :integer
    add_column :reviews, :skill, :string
  end
end
