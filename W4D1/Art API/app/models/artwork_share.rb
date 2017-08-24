class ArtworkShare < ApplicationRecord
  validates :artwork_id, uniqueness: {scope: :viewer_id}
  validates :artwork_id, :viewer_id, presence: true

  belongs_to :viewer,
    primary_key: :id,
    foreign_key: :viewer_id,
    class_name: :User

  belongs_to :artwork,
    primary_key: :id,
    foreign_key: :artwork_id,
    class_name: :Artwork
end
