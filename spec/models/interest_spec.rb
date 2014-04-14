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
    it "returns the node searched for" do
      a = Interest.new({name:"Batman Begins",category:'Movie'})
      b = Interest.find("Movie","Batman Begins")
      expect(b.name).to eq(a.name)
    end
  end
end


