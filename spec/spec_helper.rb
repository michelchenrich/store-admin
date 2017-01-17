require_relative '../extensions/object_extension.rb'

class LibraryLoader
  def self.require_all_files
    Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each { |file| require file }
  end
end

module UseCaseTestHelpers
  extend RSpec::SharedContext

  let(:memory) { FakeMemory.new }
  let(:request) { FakeRequest.new }
  let(:response) { FakeReceiver.new }
  subject { described_class.new memory, request, response }

  def given_product data
    CreateProductUseCase.new(memory, FakeRequest.new(data), NullReceiver.new).execute
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
      @data[name] = arguments.size == 1 ? arguments[0] : arguments
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
