class CheckoutUseCase
  collaborators :memory, :request, :receiver

  def execute
    receiver.total request.scans.map { |s| find_product(s).price }.reduce(&:+)
  end

  private

  def find_product scan
    memory.find_by_id scan
  end
end
