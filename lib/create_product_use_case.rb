class CreateProductUseCase
  collaborators :memory, :request, :response

  def execute
    memory.save make_product
    response.success
  end

  private
  
  def make_product
    Product.new(request.id, request.price)
  end
end
