//
//  CartItemViewModel.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 8.01.2024.
//

class CartItemViewModel {
    var product: ProductModel
    var quantity: Int

    init(product: ProductModel, quantity: Int = 1) {
        self.product = product
        self.quantity = quantity
    }

    func increaseQuantity() {
        quantity += 1
    }

    func decreaseQuantity() -> Bool {
        if quantity > 1 {
            quantity -= 1
            return true
        } else {
          
            return false
        }
    }
}
