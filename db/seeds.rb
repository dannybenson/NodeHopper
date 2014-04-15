#needs unique node implementation for all nodes

require 'json'

json = JSON.parse(File.read('db/kl.json'))
json = json | JSON.parse(File.read('db/cj.json'))
json = json | JSON.parse(File.read('db/gs.json'))
json = json | JSON.parse(File.read('db/ka.json'))
json = json | JSON.parse(File.read('db/ss.json'))


# reject users without likes
json = json.reject{ |obj| obj["likes"].nil? }

# map json categories to neo4j schema
categories = {"Movie" => "Movie", "Music" => "Musician/band", "Tv" => "Tv show", "Book" => "Book", "Non-profit" => "Non-profit organization", "Author" => "Author", "Videogame" => "Video game", "Game" => "Games/toys"}

# seed data
json.each do |obj|
  @neo = ClientHelper.get_client
  person = @neo.create_node("user_id_hash" => obj["id"].hash)
  @neo.add_label(person, "Person")
  categories.each do |schema, category|
    filter_likes = obj["likes"]["data"].select {|like| like["category"] == category }
    filter_likes.each do |like|
      interest = Interest.find_or_create_by(schema, like["name"])
      @neo.create_relationship("like", person, interest)
    end
  end
end

# create indicies
@neo.create_schema_index("Interest", ['name'])
categories.keys.each do |category|
  @neo.create_schema_index(category, ['name'])
end


