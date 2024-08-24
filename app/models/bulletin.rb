# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :category

  has_one_attached :image

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image,
            presence: true,
            file_size: { less_than: 5.megabytes },
            file_content_type: { allow: %w[image/jpg image/jpeg image/png] }

  aasm column: 'state' do
    state :draft, initial: true
    state :under_moderation
    state :published
    state :rejected
    state :archived

    event :to_moderate do
      transitions from: :draft, to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft under_moderation reject], to: :archived
    end
  end
end
