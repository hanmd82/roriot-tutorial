class API::V1::MeasurementsController < ApplicationController
  def index
    if params[:type].nil? || Measurement.has_type?(params[:type])
      @measurements = Measurement.filter_by_type(params[:type])
      render json: @measurements, each_serializer: MeasurementSerializer
    else
      render json: { "message" => "Invalid Measurement Type" }, status: :not_found
    end
  end
end
