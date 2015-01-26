class API::V1::MeasurementsController < ApplicationController
  def index
    @measurements = Measurement.all
    render json: @measurements, each_serializer: MeasurementSerializer
  end
end
