class Article < ApplicationRecord
  belongs_to :user

  #titleのvalidationを設定
  validation :title, presence: true
  validation :text, presence: true
end
