class Review < ApplicationRecord
  belongs_to :user
  belongs_to :superpower

  validates :rating, presence: true, inclusion: { in: 1..5, message: "must be between 1 and 5" }
  validates :comment, presence: true, length: { maximum: 500 }
  validates :user_id, uniqueness: { scope: :superpower_id, message: "has already reviewed this superpower" }
  validate :must_have_booked

  private

  def must_have_booked
    return if user.nil? || superpower.nil?

    used = superpower.bookings.where(user: user).where("start_date <= ?", Date.current).exists?
    errors.add(:base, "You can only review a superpower once your booking has started") unless used
  end
end
