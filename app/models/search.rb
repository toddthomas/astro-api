class Search < ApplicationRecord
  def simbad_query_params
    # Ex.: Criteria=otypes%3D'Star'&OutputMode=List&output.format=ASCII&maxObject=100
    params = {}

    params[:OutputMode] = 'List'
    params[:'output.format'] = 'ASCII'
    params[:maxObject] = max_results

    model = model_class_name.constantize
    criteria = ["otypes='#{model.simbad_types}'"]

    criteria << "Vmag <= #{limiting_magnitude}" if limiting_magnitude.present?

    if constellation_abbreviation.present?
      constellation = Constellation.find_by_abbreviation(constellation_abbreviation)
      boundary_vertex_strings = constellation.boundary_vertices.map(&:to_rounded_string)
      criteria << "region(polygon, #{boundary_vertex_strings.join(', ')})"
    end

    criteria_string = criteria.join(' & ')
    params[:Criteria] = criteria_string

    params
  end
end
