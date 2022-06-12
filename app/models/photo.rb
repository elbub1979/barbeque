class Photo < ApplicationRecord
  has_one_attached :photo, dependent: :destroy do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :show, resize_to_fill: [350, 350]
  end

  belongs_to :event
  belongs_to :user

  scope :persisted, -> { where "id IS NOT NULL" }
end
