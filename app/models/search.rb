class Search < ApplicationRecord
  validates_presence_of :model_class_name
  validates_numericality_of :limiting_magnitude, allow_nil: true
  validates_inclusion_of :sort_by, in: ->(instance) { instance.model_class.sortable_attributes },
                                   message: "can't sort by that attribute"

  def simbad_query_params
    # Ex.: Criteria=otypes%3D'Star'&OutputMode=List&output.format=ASCII&maxObject=100
    params = {}

    params[:OutputMode] = 'List'
    params[:'output.format'] = 'ASCII'
    params[:maxObject] = max_results

    criteria = ["otypes='#{model_class.simbad_types}'"]

    criteria << "Vmag <= #{limiting_magnitude}" if limiting_magnitude.present?

    if constellation_abbreviation.present?
      constellation = Constellation.find(constellation_abbreviation)
      boundary_vertex_strings = constellation.boundary_vertices.map(&:to_rounded_string)
      criteria << "region(polygon, #{boundary_vertex_strings.join(', ')})"
    end

    criteria_string = criteria.join(' & ')
    params[:Criteria] = criteria_string

    params
  end

  def model_class
    model_class_name.constantize
  end
end
