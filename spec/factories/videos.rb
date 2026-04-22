FactoryBot.define do
  factory :video do
    title         { Faker::Lorem.sentence(word_count: 4) }
    youtube_id    { SecureRandom.alphanumeric(11) }
    url           { "https://www.youtube.com/watch?v=#{youtube_id}" }
    thumbnail_url { "https://i.ytimg.com/vi/#{youtube_id}/hqdefault.jpg" }
    description   { Faker::Lorem.paragraph }
    association :user
  end
end
