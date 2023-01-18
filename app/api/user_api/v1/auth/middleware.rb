module UserApi
  module V1
    module Auth
      class Middleware < Grape::Middleware::Base
        def before
          @env['api.token'] = Authenticator.new(request, params).authenticate!
          @env['api.user'] ||= @env['api.token']&.user
        end

        def request
          @request ||= ::Grape::Request.new(env)
        end

        def params
          @params ||= request.params
        end
      end
    end
  end
end