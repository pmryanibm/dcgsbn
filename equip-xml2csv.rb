require 'csv'
require 'nokogiri'
require 'open-uri'

# iterate over the files listed on the command line

#if (ARGV.length == 0)
#  puts "specify at least one input file on the command line"
#  exit 1
#end

standard_columns =
["Id",
  "Url",
  "Name",
  "DateAsOf",
  "DateCreated",
  "DateLastModified",
  "EntityHistoryUrl",
  "Affiliation",
  "Allegiance",
  "AllegianceAlias",
  "IntelligenceEvaluation",
  "SymbolCode",
  "Azimuth",
  "Category",
  "EquipmentCode",
  "LocationReason",
  "Nomenclature",
  "NomenclatureAlias",
  "Quantity"]


# collect all of the headers
all_headers = Array.new(standard_columns)
#all_headers.concat(prop_columns)
#all_headers.concat(location_columns)

csv = CSV($stdout, force_quotes: false)

# write out the headers
csv << all_headers

entity_name = 'Equipment'

# read standard input.  expect one filename per line of input.
$stdin.each do | line |
  file = line.chomp()
  doc = File.open(file) { |f| Nokogiri::XML(f) }

  #doc.css(entity_name).each do |node|
  node = doc.at_css(entity_name)

  row_hash = Hash.new('')

  # extract the standard info
  standard_columns.each do | name |
    results = doc.xpath("/#{entity_name}/#{name}")
    row_hash[name] = (!results.empty? ? results.first.content : '') 
    
  end

  # finally, write out the collected data as a row to the csv file
  csv << all_headers.collect { | key | row_hash[key] }

  #end

end

