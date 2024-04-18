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
        wishListTitleLabel.text = "위시 리스트"
        
        // 플로팅버튼 생성
        let floatingButton = UIButton(type: .system)
        floatingButton.setTitle("Delete All", for: .normal)
        floatingButton.backgroundColor = .red
        floatingButton.setTitleColor(.white, for: .normal)
        floatingButton.layer.cornerRadius = 25
        
        // 음영 추가
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        floatingButton.layer.shadowOpacity = 0.7
        floatingButton.layer.shadowRadius = 4
        
        floatingButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // 플로팅버튼 뷰로 추가
        view.addSubview(floatingButton)
        
        // 플로팅버튼 레이아웃
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingButton.widthAnchor.constraint(equalToConstant: 100),
            floatingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // 플로팅버튼 함수
    @objc func deleteButtonTapped() {
        // 데이터 불러오기
        guard let context = persistentContainer?.viewContext else { return }
        
        for product in productList {
            context.delete(product)
        }
        
        do {
            try context.save()
            
            // 데이터 업데이트 후 테이블뷰 재로드
            productList.removeAll()
            tableView.reloadData()
        } catch {
            print("Error saving context: \(error)")
        }
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
            
            // productList array에서 선택된 아이템 삭제
            self.productList.remove(at: indexPath.row)
            
            // 해당 row 테이블뷰에서 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
