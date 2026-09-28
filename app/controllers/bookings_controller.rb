class BookingsController < ApplicationController
  def index
    bookings = current_user.bookings.includes(superpower: { photo_attachment: :blob }).order(:start_date)
    @upcoming = bookings.upcoming
    @past = bookings.past.reorder(start_date: :desc)
    @reviewed_ids = current_user.reviews.pluck(:superpower_id)
  end

  def new
    redirect_to superpower_path(params[:superpower_id])
  end

  def create
    @superpower = Superpower.find(params[:superpower_id])
    @booking = @superpower.bookings.build(booking_params.merge(user: current_user))

    if @booking.save
      redirect_to bookings_path, notice: "Booked. #{@superpower.name} is yours for #{helpers.pluralize(@booking.days, 'day')}."
    else
      @reviews = @superpower.reviews.includes(:user).order(created_at: :desc)
      render "superpowers/show", status: :unprocessable_entity
    end
  end

  def destroy
    booking = current_user.bookings.find_by(id: params[:id])
    if booking
      booking.destroy
      redirect_to bookings_path, notice: "Booking cancelled."
    else
      redirect_to bookings_path, alert: "Booking not found."
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :comment)
  end
end
