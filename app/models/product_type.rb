class ProductType < ActiveHash::Base
    self.data = [
        {id: 1, name: "通常ポイント購入", price: 120, quantity: 1, plan: 'regular_point_purchase'}, 
    ]
  end