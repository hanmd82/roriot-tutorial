class MeasurementSerializer < ActiveModel::Serializer
  attributes :type, :node_guid, :recorded_at, :sequence_number

  def attributes
    object_data = object.data
    parsed_data_hash = parse_json_data(object_data)
    super.merge!(parsed_data_hash)
  end

  def parse_json_data(json_data) # convert serialized JSON string into Ruby hash with symbolized keys
    return json_data.keys.inject({}) { |hash_t, element_t| hash_t[element_t.to_sym] = json_data["#{element_t}"]; hash_t }
  end
end
