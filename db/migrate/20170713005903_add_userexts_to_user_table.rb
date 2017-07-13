class AddUserextsToUserTable < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :lastEntryTime, :integer, :default => 0
    add_column :users, :defaultCity, :string, :default => 'Vancouver'
    add_column :users, :defaultSleep, :integer, :default => 8
    add_column :users, :defaultExercise, :integer, :default => 1
  end
end
