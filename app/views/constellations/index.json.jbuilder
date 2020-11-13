json.constellations @constellations do |constellation|
  json.partial! 'constellations/constellation', constellation: constellation
end
