class Superpower < ApplicationRecord
  STRENGTHS = %w[Gentle Solid Strong Heroic Legendary].freeze

  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_one_attached :photo

  validates :name, presence: true, length: { maximum: 60 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 10_000 }
  validates :strength, inclusion: { in: STRENGTHS }

  def average_rating
    ratings = reviews.map(&:rating).compact
    return nil if ratings.empty?

    (ratings.sum.to_f / ratings.size).round(1)
  end

  def owned_by?(someone)
    someone.present? && user_id == someone.id
  end
end
