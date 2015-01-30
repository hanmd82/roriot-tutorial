class API::V1::MeasurementsController < ApplicationController
  def index
    if params[:type].nil? || Measurement.has_type?(params[:type])
      @measurements = Measurement.filter_by_type(params[:type])
                                 .filter_by_node_guid(params[:node_guid])
                                 .filter_by_time_window(params[:from], params[:to])
                                 .filter_by_cutoff_time(params[:before])
                                 .filter_by_most_recent(params[:recent])

      render json: @measurements, each_serializer: MeasurementSerializer
    else
      render json: { "message" => "Invalid Measurement Type" }, status: :not_found
    end
  end
end
