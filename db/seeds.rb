user = User.create(email: "admin@simplecmdb.com", password: "admin123")
user.add_role(:admin)  # Assign admin role

viewer = User.create(email: "viewer@simplecmdb.com", password: "viewer")
viewer.add_role(:viewer)  # Assign viewer role

# Create 10 configuration items
ci_items = []
10.times do |i|
  ci_items << ConfigurationItem.create!(
    name: "CI Item #{i + 1}",
    ci_type: ConfigurationItem::TYPES.sample,
    status: ConfigurationItem::STATUSES.sample,
    environment: ConfigurationItem::ENVIRONMENTS.sample
  )
end

# Create relationships between configuration items
ci_items.each_with_index do |ci, index|
  related_items = ci_items.sample(3) - [ci]
  ci.related_ci_ids = related_items.map(&:id)
  ci.save!
end
