class UserDetail < ApplicationRecord
  belongs_to :user
  #avatarのvalidationを設定
  validates :avatar, file_size: { less_than_or_equal_to: 100.kilobytes }
  validates :avatar,   file_content_type: { allow: ['image/jpeg', 'image/png'] }
end
