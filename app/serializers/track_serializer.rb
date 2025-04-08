# app/serializers/track_serializer.rb
class TrackSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :distance, :number_of_curves,  :elevation_track
end
