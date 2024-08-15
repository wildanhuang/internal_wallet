class Mutation < ApplicationRecord
  belongs_to :receiver, polymorphic: true
  belongs_to :sender, polymorphic: true
end
