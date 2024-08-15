class Api::V1::WalletsController < ApplicationController
  prepend_before_action :authenticate_with_api_key!

  def index
    mutations = (current_bearer.credits + current_bearer.debits).sort
    balance = 0
    mutations.each do |mutation|
      if mutation.receiver_id == current_bearer.id
        balance += mutation.nominal
      else
        balance -= mutation.nominal
      end
      mutation.balance = balance
    end

    render json: mutations, each_serializer: MutationSerializer, user: current_bearer
  end

  def balance
    render json: { balance: current_bearer.balance }
  end
end
