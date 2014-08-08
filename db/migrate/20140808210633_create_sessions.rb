class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :ip_address
      t.string :session_code
      t.datetime :last_active

      t.timestamps
    end
  end
end
