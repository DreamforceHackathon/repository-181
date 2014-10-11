class UserApiSerializer < ActiveModel::Serializer
  attributes :id, :name, :organization, :email
end
