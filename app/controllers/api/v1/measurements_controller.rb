class API::V1::MeasurementsController < ApplicationController
  def index
    if params[:type].nil? || Measurement.has_type?(params[:type])
      @measurements = Measurement.filter_by_type(params[:type])
                                 .filter_by_node_guid(params[:node_guid])
                                 .filter_by_time_window(params[:from], params[:to])
                                 .filter_by_cutoff_time(params[:before])
                                 .filter_by_most_recent(params[:recent])
                                 .paginate(page: params[:page], per_page: params[:per_page] || 25)

      render json: @measurements, each_serializer: MeasurementSerializer
    else
      render json: { "message" => "Invalid Measurement Type" }, status: :not_found
    end
  end

  def create
    @measurement = Measurement.new(measurement_params)
    if @measurement.save
      render json: @measurement, serializer: MeasurementSerializer
    else
      render json: @measurement.errors, status: 400
    end
  end

  private
    def measurement_params
      # extract node_guid, find corresponding node and link to node_id
      params[:measurement][:node_id] = Node.find_by(guid: params[:measurement][:node_guid]).try(:id)
      params.require(:measurement).permit(Measurement::COMMON_PARAMS + [:node_id, :data => Measurement.all_serialized_params])
    end
end
