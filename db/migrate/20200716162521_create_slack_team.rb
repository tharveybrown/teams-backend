class CreateSlackTeam < ActiveRecord::Migration[6.0]
  def change
    create_table :slack_teams do |t|
      t.string :slack_id
      t.string :name
      t.belongs_to :organization, null: false, foreign_key: true
    end
  end
end
