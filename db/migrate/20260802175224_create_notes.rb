class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.references :todo, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
