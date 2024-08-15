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
    authenticate_with_http_basic do |email, password| 
      user = User.find_by(email: email)
 
      if user && user.authenticate(password) 
        api_key = user.api_keys.create! token: SecureRandom.hex 
 
        render json: api_key, status: :created and return 
      end
    end

    render status: :unauthorized
  end

  def logout
    current_api_key && current_api_key.destroy
  end
end
