module UserApi
  module V1
    module Entities
      class User < Entities::Base
        expose :id
        expose :name
      end
    end
  end
end
