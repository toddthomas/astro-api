require 'simbad'

class StarsController < ApplicationController
  def index
    simbad = Simbad.new
    simbad_response = simbad.stars('Vmag<=2.0', 'rah >= 5.0', 'rah <= 6.0', 'dec >= -10.0', 'dec <= 10.0')
    raise "error querying SIMBAD [#{response.code}]" unless simbad_response.code == 200

    stars = Commands::SimbadAsciiParser.parse(simbad_response.body)

    render json: stars, status: 200
  end

  def show
  end
end
