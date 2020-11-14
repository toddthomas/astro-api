json.star do
  json.identifier star.identifier
  json.object_type star.object_type
  json.spectral_type star.spectral_type
  json.coordinates star.coordinates.to_s
  json.visual_magnitude star.visual_magnitude
end
