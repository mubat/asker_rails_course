class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: { no_local: true }

  def gist?
    url.match?(/(https?:\/\/)?gist\.github\.com\/[\w\d\.\-\/]+/)
  end
end
