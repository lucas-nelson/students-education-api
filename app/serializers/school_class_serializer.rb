class SchoolClassSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :name

  has_one :teacher
end
