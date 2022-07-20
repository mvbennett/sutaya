class HousesController < ApplicationController
  # you can do these actions without sigining in
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # @houses = House.all
    # this covers all houses in the policy_scope
    @houses = policy_scope(House).order(created_at: :desc)
  end

  def show
    @house = House.find(params[:id])
    @booking = Booking.new
    authorize @house
  end

  def new
    # @user = User.find(current_user.id)
    @user = current_user
    @house = House.new
    # authorize is linked to house_policy.rb
    authorize @house
  end

  def create
    # @user = User.find(current_user.id)
    @user = current_user
    @house = House.new(house_params)
    @house.user = @user
    authorize @house
    if @house.save
      # should we redirect to index, the house, or somewhere else?
      redirect_to house_path(@house)
    else
      redirect_to new_house_path
    end
  end

  # def update
  #   house = House.find(params[:id])
  #   house.update(house_params)
  #   redirect_to house_path(house)
  # end

  # This does not work because of an error with the params used in the create method, check the schema
  def destroy
    # fetch the hosue from the db
    @house = House.find(params[:id])
    # destroy the house
    @house.destroy!

    authorize @house
  end

  private

  def house_params
    params.require(:house).permit(:name, :address, :haunted, :photo)
  end
end
