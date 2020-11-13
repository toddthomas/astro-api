require 'httparty'

class Simbad
  include HTTParty
  base_uri 'simbad.u-strasbg.fr/simbad'

  def stars(query_params)
    options = {query: query_params}
    self.class.get('/sim-sam', options)
  end
end
