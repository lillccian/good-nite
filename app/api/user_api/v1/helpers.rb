module UserApi::V1::SharedParamsHelper
  extend Grape::API::Helpers

  params :pagination do
    optional :page, type: Integer, default: 1
    optional :per_page, type: Integer, default: 50
  end
end

module UserApi
  module V1
    module Helpers
      def authenticate!
        current_user or raise AuthorizationError
      end

      def current_user
        @current_user ||= env['api.user']
      end

      def present_with_pagy(prefix, collection, options = {})
        present prefix, collection, **options
        present :pagination,
          {
            total_pages: collection.total_pages,
            current_page: collection.current_page,
            per_page: collection.current_per_page,
            total_count: collection.total_count
          }, with: UserApi::V1::Entities::Pagination
      end
    end
  end
end