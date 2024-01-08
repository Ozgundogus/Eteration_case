//
//  CartItemCollectionViewCell.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 8.01.2024.
//

import UIKit

class CartItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "CartItemCollectionViewCell"
    var cartItemViewModel: CartItemViewModel?
  
    var onMinusTapped: (() -> Void)?
      var onPlusTapped: (() -> Void)?
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .purple
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            productPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            quantityLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 15),
            quantityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 50),
            quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10) 
        ])


        NSLayoutConstraint.activate([
            minusButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -10),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 10),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    public func configure(with cartItemViewModel: CartItemViewModel) {
        self.cartItemViewModel = cartItemViewModel
        productNameLabel.text = cartItemViewModel.product.name
        productPriceLabel.text = "\(cartItemViewModel.product.price) ₺"
        
       
        quantityLabel.text = "\(cartItemViewModel.quantity)"
        
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }

    
    @objc private func minusButtonTapped() {
           onMinusTapped?()
       }

       @objc private func plusButtonTapped() {
           onPlusTapped?()
       }
}

