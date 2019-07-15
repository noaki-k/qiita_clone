FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    text { Faker::Markdown.unordered_list }
    #PR#38　articleはbelongs_to userなので
    #articleを作成した時はuserが作成されるように修正
    user
  end
end
