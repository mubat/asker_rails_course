class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :image, presence: true, content_type: %w[image/png image/jpg image/jpeg image/gif]

  has_one_attached :image
end
