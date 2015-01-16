require 'test_helper'

class API::V1::NodesControllerTest < ActionController::TestCase

  def setup
    @node = Node.create!(guid: 1101, label: "Node 1101 (Singapore Zoo)", lat: 1.404321, lng: 103.792937, description: "This is the node with GUID 1101 at the Singapore Zoo")
  end

  # GET /nodes
  test "GET index should be successful" do
    get :index

    assert_response :success
    assert_not_nil assigns(:nodes)
  end

  test "GET index should return the correct JSON" do
    get :index

    body = JSON.parse(response.body)
    assert_includes body, "nodes"

    nodes = body['nodes']
    assert_equal 3, nodes.length

    [:id, :created_at, :updated_at].each do |attr|
      assert_not nodes.any? {|node| node.key?("#{attr}")}
    end

    [:guid, :label, :lat, :lng, :description].each do |attr|
      assert nodes.all? {|node| node.key?("#{attr}")}
    end
  end

  test "GET index with GUID of one node should return the correct node" do
    get :index, guid: @node.guid

    body = JSON.parse(response.body)
    nodes = body['nodes']

    assert_equal 1, nodes.length
    assert_equal @node.guid, nodes.first['guid']
  end

  test "GET index with multiple GUIDs should return only the correct nodes" do
    zoo_node = @node
    night_safari_node = Node.create!(guid: 1102, label: "Node 1102 (Singapore Night Safari)", lat: 1.404322, lng: 103.792938, description: "This is the node with GUID 1102 at the Singapore Night Safari")

    valid_guids_list   = [zoo_node.guid, night_safari_node.guid]
    invalid_guids_list = [100, 200, 300]
    guids_query_list   = (valid_guids_list + invalid_guids_list).map(&:to_s).join(",")

    get :index, guid: guids_query_list

    body = JSON.parse(response.body)
    nodes = body['nodes']
    response_node_guids = nodes.collect{ |n| n['guid'] }

    assert_equal 2, nodes.length
    assert valid_guids_list.all? { |guid| response_node_guids.include?(guid) }
    assert_not invalid_guids_list.any? { |guid| response_node_guids.include?(guid) }
  end


  # GET /nodes/id
  test "GET show should be successful" do
    get :show, id: @node.id

    assert_response :success
    assert_not_nil assigns(:node)
  end

  test "GET show should return the correct JSON" do
    get :show, id: @node.id

    body = JSON.parse(response.body)
    assert_includes body, "node"

    node = body['node']
    assert_equal @node.guid, node['guid']
  end
end
