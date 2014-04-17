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
end


