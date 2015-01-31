require 'test_helper'

class NodeTest < ActiveSupport::TestCase

  context "Node" do
    setup do
      @node = Node.new(nodes(:two).attributes.except('id', 'created_at', 'updated_at').merge({"guid" => 1103}))
    end

    context "validations" do
      should "be valid by default" do
        assert @node.valid?
      end

      should "ensure presence of guid" do
        @node.guid = nil
        assert_not @node.valid?
      end

      should "ensure presence of lat" do
        @node.lat = nil
        assert_not @node.valid?
      end

      should "ensure presence of lng" do
        @node.lng = nil
        assert_not @node.valid?
      end

      should "ensure uniqueness of guid" do
        duplicate_node = @node.dup
        @node.save
        assert_not duplicate_node.valid?
      end
    end


    context "associations" do
      should "respond to measurements" do
        @node.save!
        @node.measurements.build(type: "TemperatureMeasurement", node_guid: @node.guid, recorded_at: Time.now.to_i, sequence_number: 1, data: "one")
        assert_respond_to @node, :measurements
      end
    end

  end
end

# == Schema Information
#
# Table name: nodes
#
#  id          :integer          not null, primary key
#  guid        :integer
#  label       :string(255)
#  lat         :decimal(9, 6)
#  lng         :decimal(9, 6)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
