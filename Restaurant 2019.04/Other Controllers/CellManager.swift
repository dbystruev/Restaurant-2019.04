//
//  CellManager.swift
//  Restaurant 2019.04
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class CellManager {
    func configure(_ cell: UITableViewCell, for menuItem: MenuItem) {
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            DispatchQueue.main.async {
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
}
