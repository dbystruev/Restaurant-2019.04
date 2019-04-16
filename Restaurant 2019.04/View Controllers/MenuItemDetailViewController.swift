//
//  MenuItemDetailViewController.swift
//  Restaurant 2019.04
//
//  Created by Denis Bystruev on 12/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    var menuItem: MenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        titleLabel.text = menuItem.name
        priceLabel.text = String(format: "$%.2f", menuItem.price)
        detailTextLabel.text = menuItem.detailText
        addToOrderButton.layer.cornerRadius = 5
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 3, y: 3)
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
