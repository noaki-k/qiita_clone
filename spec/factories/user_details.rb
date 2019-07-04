FactoryBot.define do
  factory :user_detail do
    avatar { "MyString" }
    sns_account { "MyString" }
    introduction { "MyText" }
    user { nil }
  end
end
