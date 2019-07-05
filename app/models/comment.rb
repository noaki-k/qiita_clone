class Comment < ApplicationRecord
  belongs_to :user

  validation :text, presence: true

end
