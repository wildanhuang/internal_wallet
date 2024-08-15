class AddAliasesForEntities < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :alias, :string
    add_column :teams, :alias, :string

    
    User.all.each do |user|
      user.update(alias: user.username)
    end

    Team.all.each do |team|
      team.update(alias: team.name)
    end
  end
end
