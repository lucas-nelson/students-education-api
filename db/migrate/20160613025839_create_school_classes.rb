# models a school class belonging to a teach and having students and lessons
class CreateSchoolClasses < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :school_classes do |t|
      t.string :name, limit: 255, null: false
      t.references :teacher, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
