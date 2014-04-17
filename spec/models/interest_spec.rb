require 'spec_helper'
require 'neography'
require 'neo4j-cypher'
# @@neo = ClientHelper.get_client

describe Interest do
  describe "self.new" do

  	it "creates a new object" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"poops",category:'thing'})
  		expect(a.name).to eq('poops')
  	end
  end
  describe "save" do
  	it "creates a node" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"sneep",category:'thing'})
  		expect(a.in_database?).to eq(false)
  		a.save
  		expect(a.in_database?).to eq(true)
      a.destroy
  	end
  end

  describe "self.create" do
    it "creates an object" do
      @neo = ClientHelper.get_client
      a = Interest.new({name:"sneep",category:'thing'})
      expect(a.in_database?).to eq(false)
      Interest.create({name:"sneep",category:'thing'})
      expect(a.in_database?).to eq(true)
      a.destroy
    end
  end

  describe "in_database?" do
  	it "returns true if the interest is in the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"Batman Begins",category:'Movie'})
  		b = a.in_database?
  		expect(b).to eq(true)
  	end 

  	it "returns false if the interest is not in the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"fleeps",category:'thing'})
  		b = a.in_database?
  		expect(b).to eq(false)
  	end
  end

  describe "destroy" do
  	it "deletes a node from the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"flimflam",category:'thing'})
  		a.save
  		expect(a.in_database?).to eq(true)
  		a.destroy
  		expect(a.in_database?).to eq(false)
  	end
  end

  describe "self.find" do
    it "returns the node searched for if it exists" do
      a = Interest.new({name:"Batman Begins",category:'Movie'})
      b = Interest.find("Batman Begins")
      expect(b.name).to eq(a.name)
    end

    it "returns nil if the node searched for does not exist" do
      b = Interest.find("dergleflerg")
      expect(b).to eq(nil)
    end
  end


  describe "self.get_interest_names" do
    it "returns correct JSON interest data" do
      interest_json = Interest.get_interest_names
      expect(interest_json.first).to eq({"name"=>"When Harry Met Sally"})
      expect(interest_json[500]).to eq({"name"=>"Justice"})
      expect(interest_json.last).to eq({"name"=>"Dungeon World"})      
    end
  end

  describe "self.find_or_create_by" do
    it "finds an existing interest in the database" do
      @neo = ClientHelper.get_client
      test_node = Interest.find_or_create_by("thing", "whatamajig")
      expect(test_node['data']).to eq({"name"=>"whatamajig"})
      @neo.delete_node(test_node)
    end
  end

  describe "self.node_matrix" do
    it "should correct name and size data" do
      data = Interest.node_matrix("Kanye West")['children']
      expect(data.first).to eq({"name"=>"Call of Duty", "size"=>7})
      expect(data[4]).to eq({"name"=>"The Lord of the Rings", "size"=>6})
    end
  end

  describe "shovel" do
    it "creates a relationship between a person and an interest" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      b << a
      c << a
      expect(b.recommendations).to_not be_nil
      a.destroy
      b.destroy
      c.destroy
    end
  end

  describe "recommendations" do
    it "returns a recommendation array" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      b << a
      c << a
      d = b.recommendations
      expect(d).to eq([['thing','more']])
      a.destroy
      b.destroy
      c.destroy
    end
  end

    describe "weighted_recommendations" do
    it "returns a recommendation array with the number of occurrences for each recommendation" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      d = Interest.create(name: "more",category: 'thing')
      b << a
      c << a
      d << a
      e = b.weighted_recommendations
      expect(e).to eq([['thing','more',2]])
      a.destroy
      b.destroy
      c.destroy
      d.destroy
    end
  end

    describe "self.combined_recommendations" do
    it "returns a recommendation array for multiple interests" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      d = Interest.create(name: "more",category: 'thing')
      e = Interest.create(name: 'stuff2',category: 'thing')
      b << a
      c << a
      d << a
      e << a
      f = Interest.combined_recommendations([b,e])
      g = []
      4.times {g << ['thing','more'] } 
      expect(f).to eq(g)
      a.destroy
      b.destroy
      c.destroy
      d.destroy
      e.destroy
    end
  end

  describe "self.combined_weighted_recommendations" do
    it "returns a recommendation array with the number of occurrences for each recommendation for multiple interests" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      d = Interest.create(name: "more",category: 'thing')
      e = Interest.create(name: 'stuff2',category: 'thing')
      b << a
      c << a
      d << a
      e << a
      f = Interest.combined_weighted_recommendations([b,e])
      expect(f).to eq([['thing','more',4]])
      a.destroy
      b.destroy
      c.destroy
      d.destroy
      e.destroy
    end
  end

  describe "self.combined_percentage_recommendations" do
    it "returns a recommendation array with the percentage of each recommendation for multiple interests" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      d = Interest.create(name: "more",category: 'thing')
      e = Interest.create(name: 'stuff2',category: 'thing')
      b << a
      c << a
      d << a
      e << a
      f = Interest.combined_percentage_recommendations([b,e])
      expect(f).to eq([['thing','more',1]])
      a.destroy
      b.destroy
      c.destroy
      d.destroy
      e.destroy
    end
  end 

  describe "self.combined_donut" do
    it "returns data formatted for the recommendation chart" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      d = Interest.create(name: "more",category: 'thing')
      e = Interest.create(name: 'stuff2',category: 'thing')
      b << a
      c << a
      d << a
      e << a
      f = Interest.combined_donut([b,e])
      expect(f).to eq({"title"=>"", "children"=>[{"title"=>"thing", "children"=>[{"title"=>"more", "data"=>1.0}]}]})
      a.destroy
      b.destroy
      c.destroy
      d.destroy
      e.destroy
    end
  end 

  describe "self.venn" do
    it "returns data formatted for the venn diagram" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      d = Interest.create(name: "more",category: 'thing')
      e = Interest.create(name: 'stuff2',category: 'thing')
      b << a
      c << a
      d << a
      e << a
      f = Interest.venn([b,e])
      expect(f).to eq({"set"=>[{"label"=>"stuff", "size"=>1}, {"label"=>"stuff2", "size"=>1}],"overlap"=>[{:sets=>[0, 1], :size=>1}]})
      a.destroy
      b.destroy
      c.destroy
      d.destroy
      e.destroy
    end
  end 
end


