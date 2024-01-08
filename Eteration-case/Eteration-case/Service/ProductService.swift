//
//  ProductService.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 6.01.2024.
//

import Foundation

class ProductService {
    let urlString = "https://5fc9346b2af77700165ae514.mockapi.io/products"

    func fetchProducts(completion: @escaping (Result<ProductsData, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            do {
                let products = try JSONDecoder().decode(ProductsData.self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
