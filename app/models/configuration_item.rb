class ConfigurationItem < ApplicationRecord
  TYPES = %w[Server Application Database]
  STATUSES = %w[Active Retired Maintenance]
  ENVIRONMENTS = %w[Production Staging Development]

  validates :name, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :environment, inclusion: { in: ENVIRONMENTS }

  has_many :ci_relationships, foreign_key: :parent_id, class_name: 'CiRelationship', dependent: :destroy
  has_many :related_cis, through: :ci_relationships, source: :child
end
