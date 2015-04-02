class CreateVisitations < ActiveRecord::Migration
  def up
    create_table :visitations do |t|
      t.integer :user_id
      t.string :country_code
    end
  end

  def down
  	drop_table :visitations
  end
end
