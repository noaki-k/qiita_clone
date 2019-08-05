class Api::V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :updated_at, :status

  belongs_to :user
  has_many :article_likes
  has_many :comments
end
