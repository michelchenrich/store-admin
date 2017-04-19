require_relative '../extensions/object_extension.rb'

class LibraryLoader
  def self.require_all_files
    Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each { |file| require file }
  end
end

class FakeGateway
  def initialize
    @data = {}
  end

  def save identifiable
    @data[identifiable.id] = identifiable.clone 
  end

  def all
    @data.values
  end

  def find_by_id id
    raise ArgumentError, "ID #{id} not found" if !@data.include? id
    @data[id]
  end

  def has_with_id id
    @data.include? id
  end
end

module ProductHelpers
  def given_product data
    subject.create_product Memory.new data
  end

  def it_should_have_created_the_product data
    request = Memory.new id: data[:id]
    r = subject.handle_product_presentation request
    expect(r).to eq data
  end
end

module DiscountHelpers
  def given_discount data
    subject.handle_discount_creation Memory.new data
  end
end

module UseCaseTestHelpers
  extend RSpec::SharedContext
  include ProductHelpers
  include DiscountHelpers

  let(:empty_request) { Hash.new }
  subject { Application.new FakeGateway.new, FakeGateway.new }

  def it_should_respond_with expectations
    expect(@response).to eq expectations
  end
end

LibraryLoader.require_all_files
