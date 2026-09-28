class ReviewsController < ApplicationController
  def create
    superpower = Superpower.find(params[:superpower_id])
    review = superpower.reviews.build(review_params.merge(user: current_user))

    if review.save
      redirect_to superpower_path(superpower, anchor: "reviews"), notice: "Thanks for the review."
    else
      redirect_back fallback_location: bookings_path, alert: review.errors.full_messages.to_sentence
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
