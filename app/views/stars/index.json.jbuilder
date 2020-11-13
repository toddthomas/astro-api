json.search do
  json.params do
    json.(
      @search,
        :model_class_name,
        :constellation_abbreviation,
        :limiting_magnitude,
        :max_results,
        :sort_by
    )
  end

  json.result_count @stars.count

  json.results @stars do |star|
    json.partial! 'stars/star', star: star
  end
end
