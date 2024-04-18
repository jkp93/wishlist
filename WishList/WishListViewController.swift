//
//  WishListViewController.swift
//  WishList
//
//  Created by 박중권 on 4/16/24.
//

import Foundation
import CoreData
import UIKit

class WishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    @IBOutlet weak var wishListTitleLabel: UILabel!
    
    private var productList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setProductList()
        wishListTitleLabel.text = "Wish List"
    }
    
    // CoreData에서 상품 정보를 불러와, productList 변수에 저장합니다.
    private func setProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
    }
    
    
    
    // productList의 count를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    // 각 index별 tableView cell을 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = self.productList[indexPath.row]
        
        let id = product.id
        let title = product.title ?? ""
        let price = product.price
        
        cell.textLabel?.text = "[\(id)] \(title) - \(price)$"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedProduct = self.productList[indexPath.row]
            
            // Core Data에서 선택된 아이템 삭제
            if let context = self.persistentContainer?.viewContext {
                context.delete(selectedProduct)
                do {
                    try context.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            }
            
            // Remove the selected product from the productList array
            self.productList.remove(at: indexPath.row)
            
            // Remove the corresponding row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
