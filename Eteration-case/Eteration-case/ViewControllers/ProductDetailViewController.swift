//
//  ProductDetailViewController.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 7.01.2024.
//
import UIKit

class ProductDetailViewController: UIViewController {
    
   
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var product: ProductModel?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price:"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .blue
        return label
    }()

    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18,weight: UIFont.Weight.bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
   
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [imageView, nameLabel, descriptionLabel,priceTitleLabel ,priceLabel, addToCartButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor),
            
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            priceLabel.centerYAnchor.constraint(equalTo: priceTitleLabel.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceTitleLabel.trailingAnchor, constant: 8),
            
     
            addToCartButton.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToCartButton.widthAnchor.constraint(equalToConstant: 150),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
            addToCartButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureViews() {
        nameLabel.text = product?.name
        descriptionLabel.text = product?.description
        priceLabel.text = "\(product?.price ?? "") ₺"
        if let imageUrl = product?.image, let url = URL(string: imageUrl) {
            loadImage(from: url)
        }
        
        addToCartButton.addTarget(self, action: #selector(addToCartPressed), for: .touchUpInside)
    }
    
    @objc private func addToCartPressed() {
        CoreDataManager.shared.addToCart(product: product!, quantity: 1)
        print("Add to Cart pressed for \(product?.name ?? "")")
        
        NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
