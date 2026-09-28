class SuperpowersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_superpower, only: [:show, :edit, :update, :destroy]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def index
    @query = params[:q].to_s.strip
    @superpowers = Superpower.includes(:user, :reviews, photo_attachment: :blob).order(created_at: :desc)
    if @query.present?
      term = "%#{Superpower.sanitize_sql_like(@query)}%"
      @superpowers = @superpowers.where("name ILIKE :term OR description ILIKE :term", term: term)
    end
  end

  def show
    @booking = Booking.new
    @reviews = @superpower.reviews.includes(:user).order(created_at: :desc)
  end

  def new
    @superpower = Superpower.new(strength: "Solid")
  end

  def create
    @superpower = current_user.superpowers.build(superpower_params)
    if @superpower.save
      redirect_to @superpower, notice: "#{@superpower.name} is listed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @superpower.update(superpower_params)
      redirect_to @superpower, notice: "Listing updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @superpower.destroy
    redirect_to superpowers_path, notice: "Listing deleted."
  end

  private

  def set_superpower
    @superpower = Superpower.find_by(id: params[:id])
    redirect_to superpowers_path, alert: "That superpower doesn't exist." unless @superpower
  end

  def require_owner
    return if @superpower.owned_by?(current_user)

    redirect_to superpower_path(@superpower), alert: "You can only change your own listings."
  end

  def superpower_params
    params.require(:superpower).permit(:name, :description, :price, :strength, :photo)
  end
end
