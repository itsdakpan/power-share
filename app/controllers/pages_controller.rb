class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @superpowers = Superpower.left_joins(:reviews).group(:id)
                              .order(Arel.sql("AVG(reviews.rating) DESC NULLS LAST, COUNT(reviews.id) DESC"))
                              .includes(:user, :reviews, photo_attachment: :blob).limit(3)
  end
end
