//
//  MenuController.swift
//  Restaurant 2019.04
//
//  Created by Denis Bystruev on 09/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class MenuController {
    let baseURL = URL(string: "http://api.armenu.net:8090/")!
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    static var shared: MenuController = MenuController()
    
    private init() {}
    
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        let categoryURL = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoryURL) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let categories = jsonDictionary?["categories"] as? [String]
            
            completion(categories)
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(nil)
            return
        }
        
        let baseURLComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.host = baseURLComponents.host
        
        guard let imageURL = components.url else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
    
    func fetchMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data)
            completion(menuItems?.items)
        }
        task.resume()
    }
    
    func submitOrder(forMenuIDs menuIds: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let preparationTime = try? JSONDecoder().decode(PreparationTime.self, from: data)
            completion(preparationTime?.prepTime)
        }
        task.resume()
    }
}
