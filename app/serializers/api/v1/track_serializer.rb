module Api
  module V1
  class TrackSerializer < ActiveModel::Serializer
    attributes :id, :name, :country, :distance, :number_of_curves,  :elevation_track
  end
  end
end
