class Node < ActiveRecord::Base
  validates :guid, presence: true,
                   uniqueness: true

  validates :lat, presence: true
  validates :lng, presence: true

  scope :filter_by_guid, -> (guid) { where(guid: guid) if guid }
end

# == Schema Information
#
# Table name: nodes
#
#  id          :integer          not null, primary key
#  guid        :integer
#  label       :string(255)
#  lat         :decimal(9, 6)
#  lng         :decimal(9, 6)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
