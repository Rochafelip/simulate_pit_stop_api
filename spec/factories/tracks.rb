FactoryBot.define do
    factory :track do
        name { "Interlagos" }
        distance { 4.3 }
        number_of_curves { 15 }
        country { "Brazil" }
        elevation_track { 43 }
    end
  end
