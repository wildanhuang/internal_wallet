class Mutation < ApplicationRecord
  attr_accessor :balance

  belongs_to :receiver, polymorphic: true
  belongs_to :sender, polymorphic: true

  after_initialize :init

  def init
    self.balance = 0
  end
end
