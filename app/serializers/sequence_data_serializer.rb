class SequenceDataSerializer < ActiveModel::Serializer
  attributes :id, :updated_at, :title, :daily_data
end
