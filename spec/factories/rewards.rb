FactoryBot.define do
  factory :reward do
    name { "MyString" }
    image { Rack::Test::UploadedFile.new('spec/fixtures/test_img.jpg', 'image/jpg') }
  end
end
