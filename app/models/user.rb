class User < ApplicationRecord
  attr_accessor :password

  has_many :api_keys, as: :bearer

  before_create :generate_digest_password
  
  def authenticate(password)
    digest_password(password) == self.password_digest
  end

  def generate_digest_password
    self.password_digest = digest_password(self.password)
  end  

  def digest_password(password)
    Digest::SHA2.new(512).hexdigest(password)
  end

end
