require 'test_helper'

class API::V1::MeasurementsControllerTest < ActionController::TestCase

  # GET /measurements
  test "GET index should be successful" do
    get :index

    assert_response :success
    assert_not_nil assigns(:measurements)
  end

  test "GET index should return the correct JSON" do
    get :index

    body = JSON.parse(response.body)
    assert_includes body, "measurements"

    measurements = body['measurements']
    assert_equal 3, measurements.length

    [:id, :created_at, :updated_at, :node_id, :data].each do |attr|
      assert_not measurements.any? {|m| m.key?("#{attr}")}
    end

    [:type, :node_guid, :recorded_at, :sequence_number].each do |attr|
      assert measurements.all? {|m| m.key?("#{attr}")}
    end
  end
end
