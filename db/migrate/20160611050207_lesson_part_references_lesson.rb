class LessonPartReferencesLesson < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    add_reference :lesson_parts, :lesson, foreign_key: true, index: true, null: false

    add_index :lesson_parts, [:lesson_id, :ordinal], unique: true
  end
end
