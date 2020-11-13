module Commands::SearchFinder
  # Find an existing search that would give the same search results. Attributes related to presentation,
  # for example, `:sort_order`, are irrelevant.
  def self.find_equivalent_of(search)
    result = Search.where(
      model_class_name: search.model_class_name,
      constellation_abbreviation: search.constellation_abbreviation,
      limiting_magnitude: search.limiting_magnitude,
      max_results: search.max_results
    ).first
  end
end
