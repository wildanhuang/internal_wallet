class Api::V1::WalletsController < ApplicationController
  prepend_before_action :authenticate_with_api_key!

  def index
    mutations = (current_bearer.credits + current_bearer.debits).sort

    render json: mutations, each_serializer: MutationSerializer, user: current_bearer
  end
end
