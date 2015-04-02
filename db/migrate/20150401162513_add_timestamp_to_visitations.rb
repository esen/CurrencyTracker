class AddTimestampToVisitations < ActiveRecord::Migration
  def change
  	alter_table :visitations do |t|
  		t.timestamps
  	end
  end
end
