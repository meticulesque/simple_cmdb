class ConfigurationItem < ApplicationRecord
  TYPES = %w[Server Application Database]
  STATUSES = %w[Active Retired Maintenance]
  ENVIRONMENTS = %w[Production Staging Development]

  self.inheritance_column = :_type_disabled
  alias_attribute :ci_type, :type

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :ci_type, inclusion: { in: TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :environment, inclusion: { in: ENVIRONMENTS }

  has_many :ci_relationships, foreign_key: :parent_id, class_name: "CiRelationship", dependent: :destroy
  has_many :related_cis, through: :ci_relationships, source: :child

  has_many :inverse_ci_relationships, foreign_key: :child_id, class_name: "CiRelationship", dependent: :destroy
  has_many :parents, through: :inverse_ci_relationships, source: :parent
end
