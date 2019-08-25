# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  has_many :comment_likes, dependent: :destroy
end
