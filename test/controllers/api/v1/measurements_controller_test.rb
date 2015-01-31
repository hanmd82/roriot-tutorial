require 'test_helper'

class API::V1::MeasurementsControllerTest < ActionController::TestCase

  # GET /measurements
  context "GET index" do

    should "be successful" do
      get :index

      assert_response :success
      assert_not_nil assigns(:measurements)
    end

    should "return the correct JSON" do
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

    should "return the JSON serialized attributes in 'data' as top-level keys" do
      get :index, type: "accelerometer"

      body = JSON.parse(response.body)
      measurements = body['measurements']

      assert_equal 2, measurements.length

      [:accel_x, :accel_y, :accel_z].each do |attr|
        assert measurements.all? {|m| m.key?("#{attr}")}
      end

      assert measurements.all? { |m| m['type'] == "AccelerometerMeasurement" }
    end

    context "filtered by modality" do
      should "return measurements of a particular type when specified" do
        get :index, type: "temperature"

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 3, measurements.length
        assert measurements.all? { |m| m['type'] == "TemperatureMeasurement" }
      end

      should "filter modality in case-insensitive manner" do
        get :index, type: "Temperature"

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 3, measurements.length
        assert measurements.all? { |m| m['type'] == "TemperatureMeasurement" }
      end

      should "only permit queries for valid measurement types" do
        get :index, type: "invalid"
        assert_response :not_found

        body = JSON.parse(response.body)
        assert_equal "Invalid Measurement Type", body['message']
      end

      should "only permit queries for non-empty measurement types" do
        get :index, type: ""
        assert_response :not_found

        body = JSON.parse(response.body)
        assert_equal "Invalid Measurement Type", body['message']
      end
    end


    context "filtered by node GUID" do
      should "return the right measurements" do
        get :index, node_guid: 1102

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 3, measurements.length
      end

      should "return measurements corresponding only to the first node's GUID" do
        get :index, node_guid: "1101,1102"

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 2, measurements.length
      end
    end


    context "filtered by timestamp" do
      should "return measurements after specified 'from' timestamp" do
        get :index, from: 30.minutes.ago.to_i

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 2, measurements.length
      end

      should "return measurements between specified 'from' and 'to' timestamps" do
        get :index, from: 3.hours.ago.to_i, to: 10.minutes.ago.to_i

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 4, measurements.length
      end

      should "not support queries with missing 'from' timestamp" do
        get :index, to: 10.minutes.ago.to_i

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 0, measurements.length
      end

      should "return measurements earlier than specified 'before' timestamp" do
        get :index, before: 10.minutes.ago.to_i

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 4, measurements.length
      end

      should "return measurements from the specified 'recent' timestamp window in seconds" do
        get :index, recent: 5 * 60

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 1, measurements.length
      end
    end


    context "pagination" do
      setup do
        35.times { |n| Measurement.create!(measurements(:accel3_two).attributes.except('id', 'created_at', 'updated_at').merge({"recorded_at" => Time.now.to_i, "sequence_number" => n})) }
      end

      should "return pages of 25 measurements by default" do
        get :index

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 25, measurements.length
        assert_equal 1102, measurements.collect{|m| m['node_guid']}.uniq.first
      end

      should "return the specified number of measurements per page" do
        get :index, per_page: 20

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 20, measurements.length
      end

      should "return the specified page of measurements" do
        get :index, page: 2

        body = JSON.parse(response.body)
        measurements = body['measurements']

        assert_equal 15, measurements.length
        assert_equal 1101, measurements.collect{|m| m['node_guid']}.uniq.last
      end
    end
  end
end
