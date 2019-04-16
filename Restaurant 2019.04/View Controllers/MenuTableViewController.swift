//
//  MenuTableViewController.swift
//  Restaurant 2019.04
//
//  Created by Denis Bystruev on 12/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var category: String!
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = category.capitalized
        
        MenuController.shared.fetchMenuItems(forCategory: category) { menuItems in
            guard let menuItems = menuItems else { return }
            
            DispatchQueue.main.async {
                self.updateUI(with: menuItems)
            }
        }
    }
    
    func updateUI(with menuItems: [MenuItem]) {
        self.menuItems = menuItems
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source
extension MenuTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier")!
        let menuItem = menuItems[indexPath.row]
        
        configure(cell, for: menuItem)
        
        return cell
    }
    
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

// MARK: - Navigation
extension MenuTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "MenuItemDetailSegue" else { return }
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
        
        let controller = segue.destination as! MenuItemDetailViewController
        controller.menuItem = menuItems[selectedRow]
    }
}
