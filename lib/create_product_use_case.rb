class CreateProductUseCase
  collaborators :memory, :request, :receiver

  def execute
    if request_is_valid?
      create
    else
      send_errors
    end
  end

  private

  def request_is_valid?
    !request.id.nil? && !request.price.nil?
  end

  def create
    memory.save make_product
    receiver.success
  end

  def make_product
    Product.new(request.id, request.price)
  end

  def send_errors
    receiver.failed
    receiver.id_is_mandatory if request.id.nil?
    receiver.price_is_mandatory if request.price.nil?
  end
end
