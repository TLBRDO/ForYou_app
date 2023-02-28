class OffersController < ApplicationController
  before_action :set_offer, only: %i[show destroy]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @offers = Offer.all
    # @offers = policy_scope(Offer)
  end

  def show
    @offer = Offer.find(params[:id])
    authorize @offer
  end

  def new
    @offer = Offer.new
    @offer.user = current_user
    authorize @offer
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.user = current_user
    authorize @offer
    if @offer.save
      redirect_to offer_path(@offer)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @offer.destroy
    redirect_to offers_path
    authorize @offer
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:price_per_day, :name, :description, :category, :address, :beginning_date, :end_date)
  end
end
