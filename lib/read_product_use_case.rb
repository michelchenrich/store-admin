class ReadProductUseCase
  collaborators :memory, :request, :receiver
 
  def execute
    product = memory.find_by_id request.id
    receiver.id product.id
    receiver.price product.price
  end
end
