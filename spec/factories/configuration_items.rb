FactoryBot.define do
  factory :configuration_item do
    name { "Test CI" }
    status { "Active" }
    environment { "Production" }
  end
end
