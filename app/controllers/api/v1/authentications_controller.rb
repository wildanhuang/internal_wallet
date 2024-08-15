class Api::V1::AuthenticationsController < ApplicationController
  include ApiKeyAuthenticatable 
 
  # Require token authentication for keys     
  prepend_before_action :authenticate_with_api_key!, only: [:keys] 
 
  # Optional token authentication for logout
  prepend_before_action :authenticate_with_api_key, only: [:logout] 

  def keys
    render json: current_bearer.api_keys
  end

  def login
    authenticate_with_http_basic do |username, password| 
      user = User.find_by(username: username)
      # create new user if not exist
      if user.blank? && username.present? && password.present?
        user = User.create(username: username, password: password)
      end
 
      if user && user.authenticate(password)
        keys = user.api_keys
        # using available key to login
        api_key = keys.present? ? keys.first : keys.create(token: SecureRandom.hex)
 
        render json: api_key, status: :created and return
      end
    end

    render json: { error: "you're not authorized." }, status: :unauthorized
  end

  def logout
    current_api_key && current_api_key.destroy
    render json: { status: "successfully logout." }
  end
end
