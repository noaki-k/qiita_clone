# frozen_string_literal: true

FactoryBot.define do
  factory :comment_like do
    user { nil }
    comment { nil }
  end
end
