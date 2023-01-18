module UserApi
  module V1
    module ExceptionHandlers
      def self.included(base)
        base.instance_eval do
          rescue_from Grape::Exceptions::ValidationErrors do |e|
            rack_response({
              error: e.message
            }.to_json, e.status)
          end

          rescue_from ApiError do |e|
            rack_response(e.message.to_json, e.status)
          end

          rescue_from ActiveRecord::RecordNotFound do
            rack_response({ 'error' => '404 Not found' }.to_json, 404)
          end

          route :any, '*path' do
            error!('404 Not Found', 404)
          end
        end
      end
    end

    class ApiError < Grape::Exceptions::Base
      attr :text, :message

      def initialize(opts={})
        @text    = opts[:text]   || ''
        @status  = opts[:status] || 400
        @message = { error: { message: @text } }
      end
    end

    class AuthorizationError < ApiError
      def initialize
        super text: 'Authorization failed', status: 401
      end
    end
  end
end