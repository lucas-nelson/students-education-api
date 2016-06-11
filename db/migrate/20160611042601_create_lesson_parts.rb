class CreateLessonParts < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :lesson_parts do |t|
      t.string :name, limit: 255, null: false
      t.integer :ordinal, null: false, numericality: { greater_than: 0, less_than_or_equal_to: 3 }

      t.timestamps
    end
  end
end
