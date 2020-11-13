FactoryBot.define do
  factory :search do
    factory :star_search do
      model_class_name { 'Star' }
      constellation_abbreviation { nil }
      limiting_magnitude { 1.0 }
    end
  end
end
