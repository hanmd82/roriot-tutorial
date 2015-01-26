class MeasurementSerializer < ActiveModel::Serializer
  attributes :type, :node_guid, :recorded_at, :sequence_number, :data
end
