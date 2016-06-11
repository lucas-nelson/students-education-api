class StudentSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :name, :email

  has_many :lesson_parts
end
