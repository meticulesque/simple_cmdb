class CiRelationship < ApplicationRecord
  belongs_to :parent, class_name: "ConfigurationItem"
  belongs_to :child, class_name: "ConfigurationItem"
end
