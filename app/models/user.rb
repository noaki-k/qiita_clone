class User < ApplicationRecord

  #nameへのvalidationを設定
  validates :name, presence: true
  validates :name, length: { maximum: 15 }

  # emailへのvalidationを設定
  validates :email, presence: true
  validates :email, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  # passwordへのvalidationを設定
  validates :password, presence: true
  validates :password, uniqueness: true
  validates :password, length: { maximum: 15 }

  #Userと他モデルのリレーションを記述
  has_one :user_detail
  has_many :articles
  has_many :article_likes
  has_many :comments
  has_many :comment_likes


end