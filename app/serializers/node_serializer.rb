class NodeSerializer < ActiveModel::Serializer
  attributes :guid, :label, :lat, :lng, :description
end
