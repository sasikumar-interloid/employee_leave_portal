FactoryBot.define do
  factory :user do
    email { "user#{SecureRandom.hex(4)}@example.com" }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    confirmed_at { Time.current }
  end
end
