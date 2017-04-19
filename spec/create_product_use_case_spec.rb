describe 'Application#handle_product_creation' do
  include UseCaseTestHelpers
  
  def when_creating_product data
    @response = subject.handle_product_creation Memory.new data
  end

  it 'fails without an id' do
    when_creating_product price: 10.0
    it_should_respond_with failed: true, id_is_mandatory: true
  end

  it 'fails without a price' do
    when_creating_product id: :product_a 
    it_should_respond_with failed: true, price_is_mandatory: true
  end

  it 'sends multiple error messages at once' do
    when_creating_product empty_request  
    it_should_respond_with failed: true, id_is_mandatory: true, price_is_mandatory: true
  end

  it 'creates successfully with a valid request' do
    when_creating_product id: :product_a, price: 10.0 
    it_should_respond_with success: true
    it_should_have_created_the_product id: :product_a, price: 10.0
  end
end
