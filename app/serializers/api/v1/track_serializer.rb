module Api
  module V1
    class TrackSerializer < ActiveModel::Serializer
      def self.call(track)
        if track.is_a?(ActiveRecord::Relation) || track.is_a?(Array)
          track.map { |t| serialize(t) }
        else
          serialize(track)
        end
      end

      def self.serialize(track)
        {
          id: track.id,
          name: track.name,
          location: track.location,
          length: track.length,
          difficulty: track.difficulty
        }
      end
    end
  end
end
