# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    point_time { Time.now }
    point_value { Faker::Number.number(2) }
  end
end
