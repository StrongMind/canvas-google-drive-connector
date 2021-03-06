# frozen_string_literal: true

require 'googleauth'
require 'googleauth/stores/redis_token_store'
require 'googleauth/web_user_authorizer'

#
# Google Oauth2 wrapper
#
class GoogleAuth
  API_SCOPE = %w(https://www.googleapis.com/auth/drive.readonly).freeze

  attr_reader :request, :user_id

  #
  # Params:
  #   - request: rack request
  #   - user_id: canvas user id
  #
  def initialize(request, user_id)
    @request = request
    @user_id = "#{user_id}@#{request.ip}"
  end

  def self.authorizer
    @authorizer ||= begin
      client_id = Google::Auth::ClientId.new(ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'])
      token_store = Google::Auth::Stores::RedisTokenStore.new(redis: AppHelpers.redis)
      callback_url = AppHelpers.url_for('/google-auth/callback')
      Google::Auth::WebUserAuthorizer.new(client_id, API_SCOPE, token_store, callback_url)
    end
  end

  def authorization_url(options = {})
    authorizer.get_authorization_url options.merge(request: request)
  end

  def authorizer
    self.class.authorizer
  end

  def callback(request)
    Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
  end

  def credentials
    @credentials ||= authorizer.get_credentials(user_id, request)
  end
end
