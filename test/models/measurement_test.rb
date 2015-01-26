require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase

  def setup
    @node = nodes(:one)
    @measurement = @node.measurements.build(type: "TemperatureMeasurement", node_guid: @node.guid, recorded_at: Time.now.to_i, sequence_number: 1, data: "one")
  end

  test "should be valid" do
    assert @measurement.valid?
  end

  # model validations
  test "node_id should be present" do
    @measurement.node_id = nil
    assert_not @measurement.valid?
  end

  test "node_guid should be present" do
    @measurement.node_guid = nil
    assert_not @measurement.valid?
  end

  test "recorded_at should be present" do
    @measurement.recorded_at = nil
    assert_not @measurement.valid?
  end

  test "data should be present" do
    @measurement.data = nil
    assert_not @measurement.valid?
  end

  # associations
  test "should respond to node" do
    assert_respond_to @measurement, :node
  end

  test "order should be most recent first" do
    assert_equal Measurement.first, measurements(:most_recent)
  end
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
