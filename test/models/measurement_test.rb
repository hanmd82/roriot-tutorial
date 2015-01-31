require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase

  context "Measurement" do
    setup do
      @node = nodes(:one)
      @measurement = @node.measurements.build(type: "TemperatureMeasurement", node_guid: @node.guid, recorded_at: Time.now.to_i, sequence_number: 1, data: "one")
    end

    context "validations" do
      should "be valid by default" do
        assert @measurement.valid?
      end

      should "ensure presence of node_id" do
        @measurement.node_id = nil
        assert_not @measurement.valid?
      end

      should "ensure presence of node_guid" do
        @measurement.node_guid = nil
        assert_not @measurement.valid?
      end

      should "ensure presence of recorded_at" do
        @measurement.recorded_at = nil
        assert_not @measurement.valid?
      end

      should "ensure presence of data" do
        @measurement.data = nil
        assert_not @measurement.valid?
      end
    end


    context "associations" do
      should "respond to node" do
        assert_respond_to @measurement, :node
      end
    end


    should "return most recent record first" do
      assert_equal Measurement.first, measurements(:most_recent)
    end
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
