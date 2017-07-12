class CreateUserexts < ActiveRecord::Migration[5.1]
  def change
    create_table :userexts do |t|
      t.integer :lastEntryTime
      t.string :defaultCity
      t.integer :defaultSleep
      t.integer :defaultExercise

      t.timestamps
    end
  end
end
