require 'pry'

# data = [{"AVOCADO" => {:price => 3.00, :clearance => true}},
# {"KALE" => {:price => 3.00, :clearance => false}},
# {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
# {"ALMONDS" => {:price => 9.00, :clearance => false}},
# {"TEMPEH" => {:price => 3.00, :clearance => true}},
# {"CHEESE" => {:price => 6.50, :clearance => false, :count => 5}},
# {"BEER" => {:price => 13.00, :clearance => false}},
# {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
# {"BEETS" => {:price => 2.50, :clearance => false}},
# {"SOY MILK" => {:price => 4.50, :clearance => true}}]
#
# cp = [
#   {:item => "AVOCADO", :num => 2, :cost => 5.00},
#   {:item => "BEER", :num => 2, :cost => 20.00},
#   {:item => "CHEESE", :num => 3, :cost => 15.00}
# ]


# apply_coupons(data, cp)


def consolidate_cart(cart)
  cons = {}
  cart.each do |hash|
    hash.each do |item, values|
      if cons[item]
        cons[item][:count]+=1
      else
        cons[item] = values
        cons[item][:count] = 1
      end
    end
  end
  cons
end


# consolidate_cart(data)

def apply_coupons(cart, coupons)
  coupons.each do |key|
    name = key[:item]
    if cart[name] && key[:num] <= cart[name][:count]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => key[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= key[:num]
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item, data|
    if data[:clearance]
      new_price = data[:price]*0.80

      data[:price]= new_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  cart_after_clearance = apply_clearance(couponed_cart)
  cart_total = 0
  cart_after_clearance.each do |item, properties|
    cart_total += properties[:price] * properties[:count]
  end
  if cart_total > 100
    cart_total = cart_total * 0.9
  end
  cart_total
end
