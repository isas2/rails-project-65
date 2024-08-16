# frozen_string_literal: true

class Bulletin < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_one_attached :image

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image,
            presence: true,
            file_size: { less_than: 5.megabytes },
            file_content_type: { allow: %w[image/jpg image/jpeg image/png] }
end
