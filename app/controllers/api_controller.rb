class ApiController < ActionController::Base

  def valid_user_token(token)
    graph = Koala::Facebook::API.new FACEBOOK_CONFIG['token'], FACEBOOK_CONFIG['secret']
    data = graph.debug_token token
    data[:is_valid]
  end
end
