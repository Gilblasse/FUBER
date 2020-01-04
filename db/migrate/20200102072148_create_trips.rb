class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer  :passenger_id
      t.integer  :driver_id
      t.string   :from
      t.string   :to    
      t.string   :status, :default => "pending"
      t.timestamps null: false
    end
  end
end
