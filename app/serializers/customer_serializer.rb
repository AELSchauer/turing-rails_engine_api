class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :created_at, :updated_at
end
