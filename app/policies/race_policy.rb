class RacePolicy < ApplicationPolicy
  def show?
    record.user == user || user.admin?
  end

  def create?
    user.present?
  end

  def update?
    record.user == user || user.admin?
  end

  def destroy?
    record.user == user || user.admin?
  end

  def index?
    user.admin? || user.present?
  end

  def permitted_attributes
    [ :id, :car_name, :car_category, :track_name, :race_time_minutes, :mandatory_pit_stop, :planned_pit_stops, :average_lap_time, :fuel_consumption_per_lap, :total_laps, :total_fuel_needed, :fuel_per_pit_stop, :estimated_pit_time ]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
            if user.admin?
        scope.all
            else
        scope.where(user_id: user.id)
            end
    end
  end
end
