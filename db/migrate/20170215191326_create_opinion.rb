class CreateOpinion < ActiveRecord::Migration[5.0]
  def change
	create_table :opinions do |t|
			t.text :client_name
			t.text :client_email
			t.text :opinion_text
			
			t.timestamps	
		end
  end
end
