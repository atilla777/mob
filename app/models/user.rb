class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable #, :omniauthable

  validates :name, length: {in: 3..300}

  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :posts, dependent: :destroy
end
