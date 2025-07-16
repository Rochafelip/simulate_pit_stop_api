FactoryBot.define do
    factory :car do
      model { "Chevette GT" }
      power { 150 } # potência em HP
      weight { 1000 } # peso em kg, garante que a razão não ultrapasse 1.0
      fuel_capacity { 60 } # litros
      category { "GT3" } # precisa ser um dos valores da lista permitida
    end
  end
