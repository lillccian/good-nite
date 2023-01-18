module ApiClient
  def api_request(method, host, path, params = {}, headers = {})
    send method, "http://#{host}#{path}", {params: params, headers: headers}
    result = JSON.parse(response.body)
    result
  end

  def user_api_request(method, path, params: {}, headers: {})
    headers = {
      'Accept': 'application/json'
    }.merge(headers)

    api_request(method, 'localhost/', path, params, headers)
  end

  def auth_user_api_request(method, path, params: {}, headers: {})
    user = @current_user || create(:user)
    access_token = user.access_tokens.create

    headers = {
      'Authorization': "Bearer #{access_token.token}"
    }.merge(headers)

    user_api_request(method, path, params: params, headers: headers)
  end
end