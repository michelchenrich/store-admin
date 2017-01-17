describe CheckoutUseCase do
  include UseCaseTestHelpers
  
  it 'returns the price of the scanned product' do 
    given_product id: :product_a, price: 10.0
    when_executed_with scans: [:product_a]
    it_should_respond_with total: 10.0 
  end

  it 'returns the total of two scans' do 
    given_product id: :product_a, price: 10.0
    when_executed_with scans: [:product_a, :product_a]
    it_should_respond_with total: 20.0 
  end
end
