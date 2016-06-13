class SchoolClassHasManyStudents < ActiveRecord::Migration[5.0] # :nodoc:
  def down
    remove_reference :students, :school_class
  end

  def up
    add_reference :students, :school_class, foreign_key: true, index: true

    # put all the students into school class #1 so we can get the foreign key column not-null
    execute <<-SQL.gsub(/^\s+/, '')
      UPDATE "students" SET "school_class_id" = 1
    SQL

    change_column_null :students, :school_class_id, false
  end
end
