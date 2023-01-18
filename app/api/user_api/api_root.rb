module UserApi
  class ApiRoot < Grape::API
    PREFIX = '/api'.freeze

    mount V1::Endpoint
  end
end