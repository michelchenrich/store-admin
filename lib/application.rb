class Application
  collaborators :products, :discounts

  def handle_product_creation request
    response = Response.new
    if !request.id.nil? && !request.price.nil?
      create_product request
      response.success
    else
      response.failed
      response.id_is_mandatory if request.id.nil?
      response.price_is_mandatory if request.price.nil?
    end
    response.build
  end

  def create_product request
    product = Product.new request.id, request.price
    products.save product
  end

  def handle_discount_creation request
    @count ||= 1
    case request.type
    when :buy_1_take_2 
      @count += 1
      discounts.save BuyOneTakeTwoDiscount.new(@count.to_s, request.product_id)
    end
  end

  def handle_product_presentation request
    product = products.find_by_id request.id

    response = Response.new
    response.id    product.id
    response.price product.price
    response.build
  end

  def handle_checkout request
    response = Response.new
    if request.scans.size == 0
      response.failed
      response.scans_are_mandatory
    else
      unknown_products = request.scans.select { |s| !products.has_with_id(s) }
      if unknown_products.empty?
        known_products = request.scans.select { |s| products.has_with_id(s) }
        scanned_products = known_products.map { |s| products.find_by_id(s) }
        total = 0.0
        all_discounts = discounts.all.map(&:new)
        discounted_products = scanned_products.map do |product|
          all_discounts.each do |discount|
            product = discount.apply product  
          end
          product
        end
        response.success
        response.total discounted_products.map(&:price).reduce(&:+) 
      else
        response.failed
        response.unknown_product_id unknown_products
      end
    end
    response.build
  end
end
