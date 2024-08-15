class Team < ApplicationRecord
  has_many :credits, class_name: 'Mutation', foreign_key: :receiver_id
  has_many :debits, class_name: 'Mutation', foreign_key: :sender_id
end
