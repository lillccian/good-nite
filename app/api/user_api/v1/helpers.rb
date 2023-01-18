module UserApi
  module V1
    module Helpers
      def authenticate!
        current_user or raise AuthorizationError
      end

      def current_user
        @current_user ||= env['api.user']
      end
    end
  end
end