class StudentWithAssociationsSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :name, :email

  belongs_to :school_class

  has_many :lesson_parts
end
