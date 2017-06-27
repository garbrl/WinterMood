class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :username
      t.string :session_key

      t.timestamps
    end
  end
end
