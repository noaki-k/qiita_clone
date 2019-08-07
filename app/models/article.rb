class Article < ApplicationRecord
  belongs_to :user
  has_many :article_likes, dependent: :destroy
  #PR #38 commentはhas_manyなのでcomments(pl)に
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :text, presence: true

  enum status: { draft: 'draft', published: 'published' }
end
