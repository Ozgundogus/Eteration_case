//
//  ProductListCollectionViewCell.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 7.01.2024.
//
import UIKit

class ProductListCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductListCollectionViewCell"
    var product: ProductModel?
    var addToCartAction: ((_ product: ProductModel) -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray 
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
     let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        applyConstraints()
        addToCartButton.addTarget(self, action: #selector(addToCartPressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addToCartButton)
    }
    
    private func applyConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            addToCartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func configure(with product: ProductModel) {
        //burası
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = "\(product.price) ₺"
        if let imageUrl = URL(string: product.image ?? "") {
            loadImage(from: imageUrl)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
    
    @objc func addToCartPressed() {
        addToCartAction?(product!)
        print("Add to Cart button pressed.")
    }
}

