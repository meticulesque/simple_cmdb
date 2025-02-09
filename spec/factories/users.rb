FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    after(:create) do |user|
      user.roles << create(:role, name: "admin")
    end
  end
end
