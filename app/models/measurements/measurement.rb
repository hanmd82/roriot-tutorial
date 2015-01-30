class Measurement < ActiveRecord::Base
  MEASUREMENT_TYPES = ["Temperature", "Accelerometer"]

  serialize :data, JSON
  validates_presence_of :node_id, :node_guid, :recorded_at, :data

  belongs_to :node

  default_scope -> { order(recorded_at: :desc) }
  scope :filter_by_type, -> (m_type) { where(type: "#{m_type.camelize}Measurement") if m_type }
  scope :filter_by_node_guid, -> (node_guid) { where(node_guid: node_guid) if node_guid }

  scope :filter_by_time_window, -> (from_timestamp, to_timestamp) { where("recorded_at between ? and ?", from_timestamp, to_timestamp || Time.now.to_i) if from_timestamp || to_timestamp }
  scope :filter_by_cutoff_time, -> (before_timestamp) { where("recorded_at < ?", before_timestamp) if before_timestamp }
  scope :filter_by_most_recent, -> (time_window_in_seconds) { where("recorded_at > ?", (Time.now - time_window_in_seconds.to_i.seconds).to_i) if time_window_in_seconds }

  def self.has_type?(m_type); MEASUREMENT_TYPES.include?(m_type.capitalize); end
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
