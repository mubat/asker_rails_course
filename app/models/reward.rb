class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :name, presence: true

  has_one_attached :image
end
