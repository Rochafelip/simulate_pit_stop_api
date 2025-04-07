# app/serializers/track_serializer.rb
class TrackSerializer < ActiveModel::Serializer
  attributes :id, :name, :distance, :number_of_curves, :country, :elevation_track, :created_at, :updated_at

  def created_at
    object.created_at.strftime('%d/%m/%Y %H:%M')
  end

  def updated_at
    object.updated_at.strftime('%d/%m/%Y %H:%M')
  end
end
