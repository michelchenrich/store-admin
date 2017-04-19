class BuyOneTakeTwoDiscount
  collaborators :id, :product_id

  def new
    DiscountIterator.new self, 0
  end

  def applies_to_product? product
    product.id == product_id
  end

  def applies_to_iteration? iteration
    iteration.even?
  end

  def percentage
    1.0
  end
end

class DiscountIterator
  collaborators :discount, :iteration
  mutates :iteration
  
  def apply product
    if discount.applies_to_product? product
      self.iteration += 1
      apply_in_iteration product, iteration
    else
      product
    end
  end

  def apply_in_iteration product, iteration
    if discount.applies_to_iteration? iteration
      DiscountedProduct.new product, discount.percentage
    else
      product
    end
  end
end

class DiscountedProduct
  collaborators :product, :percentage

  def method_missing message, *arguments, &block
    product.send(message, *arguments, &block)
  end

  def price
    product.price - ( product.price * percentage )
  end
end
