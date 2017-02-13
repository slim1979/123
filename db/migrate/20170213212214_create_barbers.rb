class CreateBarbers < ActiveRecord::Migration[5.0]
  def change  
  
		create_table :barbers do |t|
			t.text :name			
			
			t.timestamps
		end
		
		Barber.create :name => 'Василий Алибабаевич'
		Barber.create :name => 'Игорь'
		Barber.create :name => 'Сергей'
		Barber.create :name => 'Оксана'
		Barber.create :name => 'Андрей'
		Barber.create :name => 'Екатерина'
		
  end
end
