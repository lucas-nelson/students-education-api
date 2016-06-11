class CreateCompletedLessonParts < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :completed_lesson_parts do |t|
      t.references :lesson_part, foreign_key: true, index: true, null: false
      t.references :student, foreign_key: true, index: true, null: false

      t.timestamps

      t.index [:lesson_part_id, :student_id], unique: true
    end
  end
end
