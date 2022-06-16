class Photo < ApplicationRecord
  has_one_attached :photo do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :show, resize_to_fill: [350, 350]
  end

  validates :photo, file_content_type: { allow: %w[image/png image/jpg image/jpeg image/webp] }

  belongs_to :event
  belongs_to :user

  scope :persisted, -> { where "id IS NOT NULL" }
end
