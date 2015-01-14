class API::V1::NodesController < ApplicationController
  def index
    @nodes = Node.all
    render json: @nodes, each_serializer: NodeSerializer
  end

  def show
    @node = Node.find_by(id: params[:id])
    render json: @node, serializer: NodeSerializer
  end
end
