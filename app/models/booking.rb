class Booking < ApplicationRecord
  belongs_to :superpower
  belongs_to :user

  validates :start_date, :end_date, presence: true
  validates :comment, length: { maximum: 500 }
  validate :start_date_cannot_be_in_the_past, on: :create
  validate :end_date_after_start_date
  validate :not_your_own_superpower
  validate :no_overlapping_bookings

  scope :upcoming, -> { where("end_date >= ?", Date.current) }
  scope :past, -> { where("end_date < ?", Date.current) }

  def days
    return 0 if start_date.nil? || end_date.nil?

    (end_date - start_date).to_i + 1
  end

  def total_price
    days * superpower.price
  end

  def started?
    start_date <= Date.current
  end

  def past?
    end_date < Date.current
  end

  private

  def start_date_cannot_be_in_the_past
    errors.add(:start_date, "can't be in the past") if start_date.present? && start_date < Date.current
  end

  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "must be on or after the start date")
    end
  end

  def not_your_own_superpower
    errors.add(:base, "You can't book your own superpower") if superpower && user_id == superpower.user_id
  end

  def no_overlapping_bookings
    return if start_date.blank? || end_date.blank? || superpower.nil?

    clash = superpower.bookings.where.not(id: id)
                      .where("start_date <= ? AND end_date >= ?", end_date, start_date)
    errors.add(:base, "Those dates are already booked. Try different ones.") if clash.exists?
  end
end
