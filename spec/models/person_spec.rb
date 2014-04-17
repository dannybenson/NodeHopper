require 'spec_helper'
require 'neography'
require 'neo4j-cypher'
# @@neo = ClientHelper.get_client

describe Person do
  describe "self.new" do

  	it "creates a new object" do
  		@neo = ClientHelper.get_client
  		a = Person.new({user_id_hash: 11111})
  		expect(a.user_id_hash).to eq(11111)
  	end
  end

  describe "save" do
  	it "creates a node" do
  		@neo = ClientHelper.get_client
  		a = Person.new({user_id_hash: 4})
  		expect(a.in_database?).to eq(false)
  		a.save
  		expect(a.in_database?).to eq(true)
      a.destroy
  	end
  end

  describe "self.create" do
    it "creates an object" do
      @neo = ClientHelper.get_client
      a = Person.new({user_id_hash: 7})
      expect(a.in_database?).to eq(false)
      Person.create({user_id_hash: 7})
      expect(a.in_database?).to eq(true)
      a.destroy
    end
  end

  describe "in_database?" do
  	it "returns true if the interest is in the database" do
  		@neo = ClientHelper.get_client
      id = 23
  		a = Person.new({user_id_hash: id})
      a.save
  		b = a.in_database?
  		expect(b).to eq(true)
      a.destroy
  	end 

  	it "returns false if the interest is not in the database" do
  		@neo = ClientHelper.get_client
  		a = Person.new({user_id_hash: 9})
  		b = a.in_database?
  		expect(b).to eq(false)
  	end
  end

  describe "destroy" do
  	it "deletes a node from the database" do
  		@neo = ClientHelper.get_client
  		a = Person.new({user_id_hash: 5})
  		a.save
  		expect(a.in_database?).to eq(true)
  		a.destroy
  		expect(a.in_database?).to eq(false)
  	end
  end

  describe "self.find" do
    it "returns the node searched for if it exists" do
      a = Person.new({user_id_hash: 22})
      a.save
      b = Person.find(22)
      expect(b.user_id_hash).to eq(a.user_id_hash)
      a.destroy
    end

    it "returns nil if the node searched for does not exist" do
      b = Person.find(9)
      expect(b).to eq(nil)
    end
  end

    describe "shovel" do
    it "creates a relationship between a person and an interest" do
      a = Person.create(user_id_hash: 1)
      b = Interest.create(name: 'stuff',category: 'thing')
      c = Interest.create(name: "more",category: 'thing')
      a << b
      a << c
      expect(b.recommendations).to_not be_nil
      a.destroy
      b.destroy
      c.destroy
    end
  end
end


