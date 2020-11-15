module Commands::SimbadAsciiParser
  def self.parse(ascii)
    if ascii.include? 'Number of objects : ' # Possibly a big string to search. Could this be more efficient?
      Commands::SimbadAsciiMultipleResultParser.parse(ascii)
    else
      Commands::SimbadAsciiSingleResultParser.parse(ascii)
    end
  end
end

