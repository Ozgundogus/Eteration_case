//
//  CartViewController.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 7.01.2024.
//

import UIKit

class CartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private var collectionView: UICollectionView?
    var cartItem: CartItemViewModel?
  
    var cartItems: [CartItemViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadCartItems()
        NotificationCenter.default.addObserver(self, selector: #selector(loadCartItems), name: NSNotification.Name("CartUpdated"), object: nil)

    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: 100)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.register(CartItemCollectionViewCell.self, forCellWithReuseIdentifier: CartItemCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func loadCartItems() {
        let fetchedProducts = CoreDataManager.shared.fetchCartItems()

       
        var productsDict = [String: CartItemViewModel]()
        for product in fetchedProducts {
            if let existing = productsDict[product.name ?? ""] {
               
                existing.quantity += Int(product.quantity)
            } else {
                
                let tempProductModel = ProductModel(
                    createdAt: nil,
                    name: product.name ?? "",
                    image: nil,
                    description: nil,
                    model: nil,
                    brand: nil,
                    price: String(product.price),
                    id: nil
                )
                productsDict[product.name ?? ""] = CartItemViewModel(product: tempProductModel, quantity: Int(product.quantity))
            }
        }
        
        cartItems = Array(productsDict.values)
        collectionView?.reloadData()
    }



    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemCollectionViewCell.identifier, for: indexPath) as? CartItemCollectionViewCell else {
            fatalError("Unable to dequeue CartItemCollectionViewCell")
        }
        
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
      
        cell.onMinusTapped = { [weak self] in
            guard let self = self else { return }

            if indexPath.row < self.cartItems.count {
                let item = self.cartItems[indexPath.row]

                if item.quantity > 1 {
                    item.decreaseQuantity()
                    self.updateCart(item: item)
                    self.collectionView?.performBatchUpdates {
                        self.collectionView?.reloadItems(at: [indexPath])
                    }
                } else {
                    self.removeFromCart(item: item, at: indexPath)
                }
            }
        }

        cell.onPlusTapped = { [weak self] in
            guard let self = self else { return }

            if indexPath.row < self.cartItems.count {
                let item = self.cartItems[indexPath.row]
                item.increaseQuantity()
                self.updateCart(item: item)

                self.collectionView?.performBatchUpdates {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        }

        return cell
    }

    
    private func updateCart(item: CartItemViewModel) {
        CoreDataManager.shared.updateCartProduct(name: item.product.name, price: item.product.price, quantity: Int16(item.quantity))
    }
    
    
    private func removeFromCart(item: CartItemViewModel, at indexPath: IndexPath) {
            CoreDataManager.shared.removeFromCart(name: item.product.name)
            cartItems.remove(at: indexPath.row)
        collectionView?.performBatchUpdates {
               self.collectionView?.deleteItems(at: [indexPath])
           }
        }

    
    
}

