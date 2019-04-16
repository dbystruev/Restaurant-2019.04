//
//  OrderTableViewController.swift
//  Restaurant 2019.04
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    let manager = CellManager()
    var orderMinutes = 0
}

// MARK: - UIViewController Methods
extension OrderTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(
            tableView!,
            selector: #selector(UITableView.reloadData),
            name: MenuController.orderUpdatedNotification,
            object: nil
        )
    }
}

// MARK: - Table View Data Source
extension OrderTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier")!
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        
        manager.configure(cell, for: menuItem)
        
        return cell
    }
}

// MARK: - Table View Delegate
extension OrderTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }
}

// MARK: - Custom Methods
extension OrderTableViewController {
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        
        MenuController.shared.submitOrder(forMenuIDs: menuIds) { minutes in
            guard let minutes = minutes else {
                print(Date(), #line, #function, "Can't order from the server")
                return
            }
            
            self.orderMinutes = minutes
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
            }
        }
    }
}

// MARK: - Navigation
extension OrderTableViewController {
    @IBAction func unwind(segue: UIStoryboardSegue) {
        guard segue.identifier == "DismissConfirmation" else { return }
        MenuController.shared.order.menuItems.removeAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ConfirmationSegue" else { return }
        
        let viewController = segue.destination as! OrderConfirmationViewController
        viewController.minutes = orderMinutes
    }
}

// MARK: - IB Action
extension OrderTableViewController {
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0) { $0 + $1.price }
        let formattedOrder = String(format: "$%.2f", orderTotal)
        
        let alert = UIAlertController(
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(formattedOrder)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in self.uploadOrder() })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
