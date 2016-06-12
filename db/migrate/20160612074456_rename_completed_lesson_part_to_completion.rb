class RenameCompletedLessonPartToCompletion < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    rename_table :completed_lesson_parts, :completions
  end
end
