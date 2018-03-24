class User < ApplicationRecord
  has_many :books
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
