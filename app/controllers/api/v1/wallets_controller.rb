class Api::V1::WalletsController < ApplicationController
  prepend_before_action :authenticate_with_api_key!
  before_action :mutation_params, only: [:deposit, :withdraw]
  before_action :checking_entities, only: [:deposit, :withdraw]

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

  def deposit
    if @entities_present
      mutation = Mutation.create(mutation_params)

      render json: { status: "Successfully deposit #{mutation.nominal} to #{(mutation.receiver.alias rescue '-')}" }
    else
      render json: { error: "Not found." }, status: 404
    end
  end

  def withdraw
    # this method must reconsider user can take money from anyone: must have more rule later.
    if @entities_present
      mutation = Mutation.create(mutation_params)

      render json: { status: "Successfully withdraw #{mutation.nominal} from #{(mutation.sender.alias rescue '-')}" }
    else
      render json: { error: "Not found." }, status: 404
    end
  end

  private

  def mutation_params
    params.require(:wallet).permit(:receiver_type, :receiver_id, :sender_type, :sender_id, :nominal, :note)
  end

  def checking_entities    
    receiver = mutation_params[:receiver_type].constantize.find_by(id: mutation_params[:receiver_id])
    sender = mutation_params[:sender_type].constantize.find_by(id: mutation_params[:sender_id])

    @entities_present = receiver.present? && sender.present?
  end
end
