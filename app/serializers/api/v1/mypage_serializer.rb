# frozen_string_literal: true

class Api::V1::MypageSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :created_at
  belongs_to :user
end
