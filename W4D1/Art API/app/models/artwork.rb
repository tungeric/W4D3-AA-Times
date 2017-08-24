class Artwork < ApplicationRecord
  validates :title, uniqueness: {scope: :artist_id}
  validates :title, :image_url, :artist_id, presence: true

  has_many :shares,
    primary_key: :id,
    foreign_key: :artwork_id,
    class_name: :ArtworkShare

  belongs_to :artist,
    primary_key: :id,
    foreign_key: :artist_id,
    class_name: :User

    has_many :share_viewers,
      through: :shares,
      source: :viewer
end
