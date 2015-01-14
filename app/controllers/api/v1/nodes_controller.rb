class API::V1::NodesController < ApplicationController
  def index
    @nodes = Node.all
    render json: @nodes, each_serializer: NodeSerializer
  end
end
