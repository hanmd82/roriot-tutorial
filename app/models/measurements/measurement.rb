class Measurement < ActiveRecord::Base
  validates_presence_of :node_id, :node_guid, :recorded_at, :data

  belongs_to :node

  default_scope -> { order(recorded_at: :desc) }
end

# == Schema Information
#
# Table name: measurements
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  node_id         :integer
#  node_guid       :integer
#  recorded_at     :integer
#  sequence_number :integer
#  data            :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
