class CreateTeachers < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :teachers do |t|
      t.string :email, index: { unique: true }, limit: 255, null: false
      t.string :name, limit: 255, null: false

      t.timestamps
    end
  end
end
