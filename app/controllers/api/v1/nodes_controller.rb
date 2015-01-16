class API::V1::NodesController < ApplicationController
  def index
    @nodes = Node.filter_by_guid(params[:guid])
    render json: @nodes, each_serializer: NodeSerializer
  end

  def show
    @node = Node.find_by(id: params[:id])
    render json: @node, serializer: NodeSerializer
  end
end
