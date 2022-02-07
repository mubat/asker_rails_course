class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true

  validates :name, presence: true

  has_one_attached :image
end
