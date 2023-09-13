//
//  ImageView+Ext.swift
//  CathayBank
//
//  Created by wistronits on 2023/8/11.
//

import UIKit

extension UIImageView {
    func loadUrlImage(urlString: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.success(nil))
                }
            }
        }.resume()
    }
}

