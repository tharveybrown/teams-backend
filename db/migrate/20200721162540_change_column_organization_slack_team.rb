class ChangeColumnOrganizationSlackTeam < ActiveRecord::Migration[6.0]
  def change
    change_column :slack_teams, :organization_id, :integer, :null => true
  end
end
