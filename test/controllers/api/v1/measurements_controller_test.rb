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
    assert_equal 5, measurements.length

    [:id, :created_at, :updated_at, :node_id, :data].each do |attr|
      assert_not measurements.any? {|m| m.key?("#{attr}")}
    end

    [:type, :node_guid, :recorded_at, :sequence_number].each do |attr|
      assert measurements.all? {|m| m.key?("#{attr}")}
    end
  end

  test "GET index should return measurements of a particular type when specified" do
    get :index, type: "temperature"

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 3, measurements.length
    assert measurements.all? { |m| m['type'] == "TemperatureMeasurement" }
  end

  test "GET index modality filter should be case-insensitive " do
    get :index, type: "Temperature"

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 3, measurements.length
    assert measurements.all? { |m| m['type'] == "TemperatureMeasurement" }
  end

  test "GET index should only permit queries for valid measurement types" do
    get :index, type: "invalid"
    assert_response :not_found

    body = JSON.parse(response.body)
    assert_equal "Invalid Measurement Type", body['message']
  end

  test "GET index should only permit queries for non-empty measurement types" do
    get :index, type: ""
    assert_response :not_found

    body = JSON.parse(response.body)
    assert_equal "Invalid Measurement Type", body['message']
  end

  test "GET index should return the JSON serialized attributes as top-level keys" do
    get :index, type: "accelerometer"

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 2, measurements.length

    [:accel_x, :accel_y, :accel_z].each do |attr|
      assert measurements.all? {|m| m.key?("#{attr}")}
    end

    assert measurements.all? { |m| m['type'] == "AccelerometerMeasurement" }
  end

  test "GET index should filter queries by node GUID" do
    get :index, node_guid: 1102

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 3, measurements.length
  end

  test "GET index should filter queries by only the first node's GUID" do
    get :index, node_guid: "1101,1102"

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 2, measurements.length
  end

  test "GET index should filter records after specified 'from' timestamp" do
    get :index, from: 30.minutes.ago.to_i

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 2, measurements.length
  end

  test "GET index should filter records between specified 'from' and 'to' timestamps" do
    get :index, from: 3.hours.ago.to_i, to: 10.minutes.ago.to_i

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 4, measurements.length
  end

  test "GET index should not support queries with missing 'from' timestamp" do
    get :index, to: 10.minutes.ago.to_i

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 0, measurements.length
  end

  test "GET index should filter records earlier than specified 'before' timestamp" do
    get :index, before: 10.minutes.ago.to_i

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 4, measurements.length
  end

  test "GET index should filter records from the specified 'recent' timestamp window in seconds" do
    get :index, recent: 5 * 60

    body = JSON.parse(response.body)
    measurements = body['measurements']

    assert_equal 1, measurements.length
  end
end
