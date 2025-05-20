class RacePolicy < ApplicationPolicy
  # Permite que o usuário veja apenas sua própria Race
  def show?
    record.user == user || user.admin?
  end

  # Permite que o usuário crie sua própria Race
  def create?
    user.present?  # O usuário precisa estar logado
  end

  # Permite que o usuário edite sua própria Race ou um admin edite qualquer Race
  def update?
    record.user == user || user.admin?
  end

  # Permite que o usuário apague sua própria Race ou um admin apague qualquer Race
  def destroy?
    record.user == user || user.admin?
  end

  # Permite que o admin veja todas as Races
  def index?
    user.admin?
  end

  def permitted_attributes
    [ :id, :car_name, :car_category, :track_name, :race_time_minutes, :mandatory_pit_stop, :planned_pit_stops, :average_lap_time, :fuel_consumption_per_lap, :total_laps, :total_fuel_needed, :fuel_per_pit_stop, :estimated_pit_time ]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user) # Mostra apenas Races do usuário
    end
  end
end
