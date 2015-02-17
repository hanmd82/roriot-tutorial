class TemperatureMeasurement < Measurement
  SPECIAL_SERIALIZED_PARAMS = [:temperature]
end

# == Schema Information
#
# Table name: measurements
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  node_id         :integer
#  node_guid       :integer
#  recorded_at     :integer
#  sequence_number :integer
#  data            :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
