# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Node.create!(guid: 1101, label: "Node 1101 (Singapore Zoo)", lat: 1.404321, lng: 103.792937, description: "This is the node with GUID 1101 at the Singapore Zoo")
Node.create!(guid: 1102, label: "Node 1102 (Singapore Night Safari)", lat: 1.404322, lng: 103.792938, description: "This is the node with GUID 1102 at the Singapore Night Safari")
