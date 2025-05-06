module Api
  module V1
    class UserSerializer
      def self.call(user)
        {
          id: user.id,
          name: user.name,
          email: user.email
        }
      end

      def initialize(user)
        @user = user
      end
    end
  end
end
