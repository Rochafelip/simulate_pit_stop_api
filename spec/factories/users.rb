FactoryBot.define do
    factory :user do
        name { "Usuário Teste" }
        sequence(:email) { |n| "user#{n}@example.com" }
        password { "password123" }
        password_confirmation { "password123" }
        role { :normal }

        trait :admin do
          role { :admin }
        end

        trait :without_email do
          email { nil }
        end

        trait :without_password do
          password { nil }
          password_confirmation { nil }
        end
    end
end
