FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    text { Faker::Markdown.unordered_list }
  end
end
