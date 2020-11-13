json.search do
  json.params do
    json.(
      @search,
        :model_class_name,
        :constellation_abbreviation,
        :limiting_magnitude,
        :max_results
    )
  end

  json.result_count @stars.count

  json.results(@stars) do |star|
    json.identifier star.identifier

  end
end
