require 'spec_helper'
require 'neography'
require 'neo4j-cypher'
@neo = ClientHelper.get_client
p @neo.execute_query('MATCH n return n')
describe Interest do
  describe "new" do

  	it "creates a new object" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({id:1,name:"poops",category:'thing'})
  		expect(a.name).to eq('poops')
  	end
  end
  describe "save" do
  	xit "creates a node" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({id:1,name:"sneep",category:'thing'})
  		expect(a.in_database?).to eq(false)
  		a.save
  		expect(a.in_database?).to eq(true)
  	end
  end  

  describe "in_database?" do
  	it "returns true if the interest is in the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({id:1,name:"Batman Begins",category:'thing'})
  		b = a.in_database?
  		expect(b).to eq(true)
  	end 

  	it "returns false if the interest is not in the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({id:1,name:"fleeps",category:'thing'})
  		b = a.in_database?
  		expect(b).to eq(false)
  	end
  end

  describe "destroy" do
  	xit "deletes a node from the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({id:1,name:"flerp flerp",category:'thing'})
  		a.save
  		expect(a.in_database?).to eq(true)
  		a.destroy
  		expect(a.in_database?).to eq(false)
  	end
  end







end


