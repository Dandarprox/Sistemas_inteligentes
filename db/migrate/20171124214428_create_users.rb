class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :age
      t.string :mood
      t.string :liking
      t.string :gender
      t.string :ocupation
      t.string :physhic

      t.timestamps
    end
  end
end
