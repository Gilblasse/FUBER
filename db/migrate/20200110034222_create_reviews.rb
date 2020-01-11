class CreateReviews < ActiveRecord::Migration

  def change
    create_table :reviews do |t|
      t.string   :comment
      t.integer  :reviewable_id
      t.string   :reviewable_type
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :trip_id
      t.integer  :stars
    end
  end


end

