FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    text { Faker::Markdown.unordered_list }
    status { :published }
    #PR#38　articleはbelongs_to userなので
    #articleを作成した時はuserが作成されるように修正
    user

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
    end

  end
end
