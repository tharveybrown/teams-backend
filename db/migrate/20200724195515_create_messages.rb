class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :text
      t.string :slack_id
      t.string :personality
      t.string :slack_user_id
      t.belongs_to :channel, foreign_key: true
    end
  end
end
