module UserApi
  module V1
    module Auth
      class Authenticator
        def initialize(request, params)
          @request = request
          @params  = params
          @headers = request.headers
        end

        def authenticate!
          check_token!
          token
        end

        def check_token!
          return @headers['Authorization'] unless token
        end

        def token
          return nil unless @headers['Authorization']&.match?(/Bearer ([\w|-]+)/)

          auth_token = @headers['Authorization'].match(/Bearer ([\w|-]+)/)[1]
          @token = AccessToken.joins(:user).where(token: auth_token).first
        end
      end
    end
  end
end