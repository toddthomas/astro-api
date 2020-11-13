require 'simbad'

class StarsController < ApplicationController
  def index
    @search = Search.new
    @search.model_class_name = 'Star'
    @search.constellation_abbreviation = params[:constellation_id]
    @search.limiting_magnitude = params[:limiting_magnitude]
    @search.max_results = params[:max_results] if params.has_key?(:max_results)
    @search.sort_by = params[:sort_by] || @search.model_class.default_sort
    unless @search.valid?
      raise InvalidQueryError, @search.errors.messages
    end

    simbad = Simbad.new
    simbad_response = simbad.stars(@search.simbad_query_params)
    raise SimbadError, "SIMBAD responded with error code [#{response.code}]" unless simbad_response.code == 200

    @stars = Commands::SimbadAsciiParser.parse(simbad_response.body)
    @stars.sort_by! { |star| star.send(@search.sort_by.to_sym) }
  end
end
