//
//  ViewController.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 6.01.2024.
//

import UIKit

class ProductListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var products: ProductsData = []
    var filteredProducts: ProductsData = []
    var isFetchingMoreProducts = false
    let productService = ProductService()
    
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search for products"
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let padding: CGFloat = 10
    let totalPadding = padding * 3
    let availableWidth = view.frame.width - totalPadding
    let widthPerItem = availableWidth / 2
    layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    layout.minimumLineSpacing = padding
    layout.minimumInteritemSpacing = padding
    layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(ProductListCollectionViewCell.self, forCellWithReuseIdentifier: ProductListCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.contentInsetAdjustmentBehavior = .automatic
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        view.addSubview(collectionView)
        fetchProducts()
    }

    
    private func fetchProducts() {
        guard !isFetchingMoreProducts else { return }
        isFetchingMoreProducts = true

        self.productService.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                self?.isFetchingMoreProducts = false
                switch result {
                case .success(let fetchedProducts):
                    self?.products.append(contentsOf: fetchedProducts)
                    if let products = self?.products {
                        self?.filteredProducts = products
                    } else {
                        self?.filteredProducts = []
                    }
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error fetching products: \(error)")
                }
            }
        }

    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredProducts = products
            collectionView.reloadData()
            return
        }
        filteredProducts = products.filter { product in
            product.name.lowercased().contains(searchText.lowercased())
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredProducts = products
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.identifier, for: indexPath) as? ProductListCollectionViewCell else {
            fatalError("Unable to dequeue ProductListCollectionViewCell")
        }
        let product = filteredProducts[indexPath.row]
        cell.configure(with: product)
        cell.addToCartAction = { [weak self] in
            self?.addToCartButtonTapped(product)
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = filteredProducts[indexPath.row]
        let detailViewController = ProductDetailViewController()
        detailViewController.product = product
        navigationController?.pushViewController(detailViewController, animated: true)
    }


 
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            fetchProducts()
        }
    }
    func addToCartButtonTapped(_ product: ProductModel) {
        CoreDataManager.shared.addToCart(name: product.name, price: product.price, quantity: 1)
        print("Added to cart: \(product.name)")
        NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
    }
}
