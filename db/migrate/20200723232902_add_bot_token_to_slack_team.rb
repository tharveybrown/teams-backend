class AddBotTokenToSlackTeam < ActiveRecord::Migration[6.0]
  def change
    add_column :slack_teams, :bot_token, :string
  end
end
