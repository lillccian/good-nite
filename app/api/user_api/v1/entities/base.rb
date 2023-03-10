module UserApi
  module V1
    module Entities
      class Base < Grape::Entity
        format_with(:iso8601) { |dt| dt.iso8601 }
      end
    end
  end
end
