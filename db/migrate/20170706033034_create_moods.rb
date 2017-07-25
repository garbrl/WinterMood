class CreateMoods < ActiveRecord::Migration[5.1]
  def change
    create_table :moods do |t|
      t.integer :userid
      t.string :city
      t.integer :mood
      t.float :sleep
      t.float :exercise
      t.integer :overcast

      t.timestamps
    end
  end
end
