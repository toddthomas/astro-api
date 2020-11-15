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

    # Has this search been successfully completed before?
    existing_search = Commands::SearchFinder.find_equivalent_of(@search)
    if existing_search
      Rails.logger.info "we've done search #{@search} before, so its results could be stored locally"
      # TODO: actually store the results locally and use them next time.
    end

    simbad = Simbad.new
    simbad_response = simbad.stars(@search.simbad_query_params)
    unless simbad_response.code == 200
      message = "SIMBAD responded with error code [#{response.code}]"
      Rails.logger.error message + " and body [#{response.body[..100]}"
      raise SimbadError, message
    end

    @stars = Commands::SimbadAsciiParser.parse(simbad_response.body)
    @stars.sort_by! { |star| star.send(@search.sort_by.to_sym) }

    # Simbad query succeeded. Save the search.
    begin
      # TODO: If we were saving result objects, we wouldn't have gotten here.
      @search.save! unless existing_search
    rescue ActiveRecordError::ConflictError
      # Might happen if the service has lots of concurrent users. Probably not a problem, but keep track of it.
      Rails.logger.info "same search #{@search} completed since the start of this request"
    end
    # TODO: here's where we'd save the stars found by the search for faster response to the same search next time.
  end

  def show
    simbad = Simbad.new
    simbad_response = simbad.star(params[:id])
    unless simbad_response.code == 200
      message = "SIMBAD responded with error code [#{response.code}]"
      Rails.logger.error message + " and body [#{response.body[..100]}"
      raise SimbadError, message
    end

    @star = Commands::SimbadAsciiSingleResultParser.parse(simbad_response)
  end
end
