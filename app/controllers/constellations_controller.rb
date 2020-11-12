class ConstellationsController < ApplicationController
  def index
    render json: Constellation.all, status: 200
  end

  def show
    constellation = Constellation.all.select { |const| const.name.downcase == params[:id].downcase }.first
    render json: constellation, status: 200
  end
end
