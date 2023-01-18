module UserApi
  module V1
    module Auth
      class Authenticator
        def initialize(request, params)
          @request = request
          @params  = params
        end

        def authenticate!
          check_token!
          token
        end

        def check_token!
          return @params[:access_token] unless token
        end

        def token
          @token = AccessToken.joins(:user).where(token: @params[:access_token]).first
        end
      end
    end
  end
end