require 'test_helper'

class API::V1::NodesControllerTest < ActionController::TestCase

  # GET /nodes
  context "GET index" do
    should "be successful" do
      get :index

      assert_response :success
      assert_not_nil assigns(:nodes)
    end

    should "return the correct JSON" do
      get :index

      body = JSON.parse(response.body)
      assert_includes body, "nodes"

      nodes = body['nodes']
      assert_equal 2, nodes.length

      [:id, :created_at, :updated_at].each do |attr|
        assert_not nodes.any? {|node| node.key?("#{attr}")}
      end

      [:guid, :label, :lat, :lng, :description].each do |attr|
        assert nodes.all? {|node| node.key?("#{attr}")}
      end
    end

    should "should return the correct node" do
      @node = nodes(:one)
      get :index, guid: @node.guid

      body = JSON.parse(response.body)
      nodes = body['nodes']

      assert_equal 1, nodes.length
      assert_equal @node.guid, nodes.first['guid']
    end

    should "return only the correct nodes when given multiple GUIDs" do
      zoo_node = nodes(:one)
      night_safari_node = nodes(:two)

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
  end


  # GET /nodes/id
  context "GET show" do
    setup do
      @node = nodes(:one)
    end

    should "be successful" do
      get :show, id: @node.id

      assert_response :success
      assert_not_nil assigns(:node)
    end

    should "return the correct JSON" do
      get :show, id: @node.id

      body = JSON.parse(response.body)
      assert_includes body, "node"

      node = body['node']
      assert_equal @node.guid, node['guid']
    end
  end
end
