//
//  ProductModel.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 6.01.2024.
//

import Foundation


struct ProductModel: Codable {
    let createdAt: String?
    let name: String
    let image: String?
    let description: String?
    let model: String?
    let brand: String?
    let price: String
    let id: String?
}


typealias ProductsData = [ProductModel]
