class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :host
      t.integer :port
      t.datetime :last_seen

      t.timestamps
    end
  end
end
