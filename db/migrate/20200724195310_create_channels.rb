class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.belongs_to :slack_team, null: true, foreign_key: true
      t.string :slack_id
      t.string :name
      t.boolean :is_general
      t.boolean :bot_invited
    end
  end
end
