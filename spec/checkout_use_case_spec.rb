describe 'Application#handle_checkout' do
  include UseCaseTestHelpers

  def when_scanning_with data
    @response = subject.handle_checkout Memory.new data
  end

  it 'fails when given no scans' do 
    given_product id: :product_a, price: 10.0
    when_scanning_with scans: []
    it_should_respond_with failed: true, scans_are_mandatory: true 
  end

  it 'returns the price of the scanned product' do 
    given_product id: :product_a, price: 10.0
    when_scanning_with scans: [:product_a]
    it_should_respond_with success: true, total: 10.0 
  end

  it 'returns the total of two scans' do 
    given_product id: :product_a, price: 10.0
    when_scanning_with scans: [:product_a, :product_a]
    it_should_respond_with success: true, total: 20.0 
  end

  it 'fails when given an unknown product id' do
    given_product id: :product_a, price: 10.0
    when_scanning_with scans: [:product_b, :product_c]
    it_should_respond_with failed: true, unknown_product_id: [:product_b, :product_c]
  end

  it 'failure with unknown product id does not proceed with checkout' do
    given_product id: :product_a, price: 10.0
    when_scanning_with scans: [:product_a, :product_b]
    it_should_respond_with failed: true, unknown_product_id: [:product_b]
  end

  it 'applies buy 1 take 2 discount' do
    given_product id: :product_a, price: 10.0
    given_discount type: :buy_1_take_2, product_id: :product_a
    when_scanning_with scans: [:product_a, :product_a]
    it_should_respond_with success: true, total: 10.0
  end
end
