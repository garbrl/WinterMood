class AddUserextsToUserTable < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :lastEntryTime, :integer, :default => 0
    add_column :users, :defaultCity, :string, :default => 'Vancouver'
    add_column :users, :defaultSleep, :float, :default => 8.0
    add_column :users, :defaultExercise, :float, :default => 0.5
  end
end
