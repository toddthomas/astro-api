require 'httparty'

class Simbad
  include HTTParty
  base_uri 'simbad.u-strasbg.fr/simbad'

  def stars(*criteria)
    query = ascii_list_params
    query.merge! limit_param(limit: 100)
    query.merge! criteria_param("otypes='*'", *criteria)
    options = {query: query}
    self.class.get('/sim-sam', options)
  end

  private

  def ascii_list_params
    {'OutputMode': 'List', 'output.format': 'ASCII'}
  end

  def limit_param(limit:)
    {'maxObject': limit.to_i}
  end

  def criteria_param(*criteria)
    return {} if criteria.empty?

    criteria_expression = criteria.join('&')

    {'Criteria': criteria_expression}
  end
end
