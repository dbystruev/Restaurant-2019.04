//
//  CategoryTableViewController.swift
//  Restaurant 2019.04
//
//  Created by Denis Bystruev on 12/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuController.shared.fetchCategories { categories in
            guard let categories = categories else {
                print(#line, #function, "Can't get the list of categories")
                return
            }
            
            DispatchQueue.main.async {
                self.updateUI(with: categories)
            }
        }
    }
    
    func updateUI(with categories: [String]) {
        self.categories = categories
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source
extension CategoryTableViewController /* : UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier")!
        let category = categories[indexPath.row]
        
        configure(cell, for: category)
        
        return cell
    }
    
    func configure(_ cell: UITableViewCell, for category: String) {
        cell.textLabel?.text = category.capitalized
    }
}

// MARK: - Navigation
extension CategoryTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "MenuSegue" else { return }
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
        
        let controller = segue.destination as! MenuTableViewController
        let category = categories[selectedRow]
        
        controller.category = category
        
    }
}
