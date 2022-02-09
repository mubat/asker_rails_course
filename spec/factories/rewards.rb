FactoryBot.define do
  factory :reward do
    name { Faker::Fantasy::Tolkien.character }
    question
    image { Rack::Test::UploadedFile.new('spec/fixtures/test_img.jpg', 'image/jpg') }
  end
end
