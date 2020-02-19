class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :password
  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: { case_sensitive: true }
  has_secure_password
end
