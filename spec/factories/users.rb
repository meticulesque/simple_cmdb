FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }  # Random email
    password { 'password123' }  # Default password for testing
    password_confirmation { 'password123' }
    confirmed_at { Time.now }  # For Devise, make sure the user is confirmed
    role { 'admin' }  # Default role; you can adjust as needed

    # You can also create more complex user roles if needed by extending it further
    trait :viewer do
      role { 'viewer' }
    end

    trait :admin do
      role { 'admin' }
    end
  end
end
