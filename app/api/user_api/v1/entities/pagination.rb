module UserApi
  module V1
    module Entities
      class Pagination < Grape::Entity
        expose :current_page
        expose :total_pages
        expose :per_page
        expose :total_count
      end
    end
  end
end
