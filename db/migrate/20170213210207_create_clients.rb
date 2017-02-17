class CreateClients < ActiveRecord::Migration[5.0]
  def change  
	create_table :clients do |t|
		t.text :name
		t.text :phone
		t.text :date
		t.text :time
		t.text :barber
		t.text :color
		
		t.timestamps	
	end	
  end
end
