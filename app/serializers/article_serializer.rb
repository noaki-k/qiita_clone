class ArticleSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :user
  has_many :article_likes, dependent: :destroy
  has_many :comment, dependent: :destroy
end
