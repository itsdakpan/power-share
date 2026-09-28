class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :superpowers, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  def display_name
    first_name.presence || email.split("@").first.titleize
  end

  def initials
    display_name.split.map { |part| part[0] }.first(2).join.upcase
  end
end
