class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.references :todo, null: false, foreign_key: false

      t.timestamps
    end
  end
end
