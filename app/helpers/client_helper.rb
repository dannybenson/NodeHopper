module ClientHelper
  def self.get_client
    Neography::Rest.new
  end
end
