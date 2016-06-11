class CreateLessons < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :lessons do |t|
      t.string :name, limit: 255, null: false
      t.integer :ordinal, null: false, numericality: { greater_than: 0 }

      t.timestamps
    end
  end
end
