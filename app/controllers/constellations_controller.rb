class ConstellationsController < ApplicationController
  def index
    @constellations = Constellation.all
  end

  def show
    @constellation = Constellation.find(params[:id])
  end
end
