require_relative '../extensions/object_extension.rb'

class LibraryLoader
  def self.require_all_files
    Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each { |file| require file }
  end
end

module UseCaseTestHelpers
  extend RSpec::SharedContext

  let(:empty_request) { Hash.new }
  let(:memory) { FakeMemory.new }
  let(:request) { FakeRequest.new }
  let(:response) { FakeReceiver.new }
  subject { described_class.new memory, request, response }

  def given_product data
    CreateProductUseCase.new(memory, FakeRequest.new(data), NullReceiver.new).execute
  end

  def it_should_have_created_the_product data
    read_request = FakeRequest.new({id: data[:id]})
    read_receiver = FakeReceiver.new
    ReadProductUseCase.new(memory, read_request, read_receiver).execute
    expect(read_receiver.received_messages).to eq data
  end

  def when_executed_with data
    request.data = data
    subject.execute
  end

  def it_should_respond_with expectations
    expect(response.received_messages).to eq expectations
  end

  class FakeMemory
    def initialize
      @data = {}
    end

    def save identifiable
      @data[identifiable.id] = identifiable.clone 
    end

    def find_by_id id
      raise ArgumentError, "ID #{id} not found" if !@data.include? id
      @data[id]
    end
  end

  class FakeRequest
    def initialize data={}
      @data = data
    end

    def responds_to? _
      true
    end

    def method_missing name, *_
      @data[name]
    end

    def data= data
      @data = data
    end
  end

  class NullReceiver
    def responds_to? _
      true
    end

    def method_missing name, *arguments
    end
  end

  class FakeReceiver
    def initialize
      @data = {}
    end

    def responds_to? _
      true
    end

    def method_missing name, *arguments
      @data[name] = value_of(arguments)
    end

    def value_of arguments
      if arguments.size == 0
        true
      elsif arguments.size == 1
        arguments[0]
      else
        arguments
      end
    end

    def received? name
      @data.include? name
    end

    def arguments_received_with name
      @data[name]
    end

    def received_messages
      @data
    end
  end
end

LibraryLoader.require_all_files
