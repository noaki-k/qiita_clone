class User < ApplicationRecord
  # Include default devise modules.
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  #Userと他モデルのリレーションを記述
  has_one :user_detail
  has_many :articles
  has_many :article_likes
  has_many :comments
  has_many :comment_likes
end