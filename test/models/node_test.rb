require 'test_helper'

class NodeTest < ActiveSupport::TestCase

  def setup
    @node = Node.new(guid: 1101, label: "Node 1101 (Singapore Zoo)", lat: 1.404321, lng: 103.792937, description: "This is the node with GUID 1101 at the Singapore Zoo")
  end

  test "should be valid" do
    assert @node.valid?
  end

  test "guid should be present" do
    @node.guid = nil
    assert_not @node.valid?
  end

  test "lat should be present" do
    @node.lat = nil
    assert_not @node.valid?
  end

  test "lng should be present" do
    @node.lng = nil
    assert_not @node.valid?
  end

  test "guid should be unique" do
    duplicate_node = @node.dup
    @node.save
    assert_not duplicate_node.valid?
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
