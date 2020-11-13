require 'simbad'

class StarsController < ApplicationController
  def index
    @search = Search.new
    @search.model_class_name = 'Star'
    @search.constellation_abbreviation = params[:constellation_id]
    @search.limiting_magnitude = params[:limiting_magnitude]
    @search.max_results = params[:max_results] if params.has_key?(:max_results)

    simbad = Simbad.new
    simbad_response = simbad.stars(@search.simbad_query_params)
    raise "error [#{response.code}] querying SIMBAD" unless simbad_response.code == 200

    @stars = Commands::SimbadAsciiParser.parse(simbad_response.body)
  end
end
