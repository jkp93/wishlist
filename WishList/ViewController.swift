//
//  ViewController.swift
//  WishList
//
//  Created by 박중권 on 4/12/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //코어데이터에 데이터를 담기 위해 persistentContainer 선언
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            //nil이 아닐 경우 가져와야되기 때문에 guard let으로 바인딩
            guard let currentProduct = self.currentProduct else
            { return }
            
            //UI 관련은 main에서 보통 관리를 함.
            DispatchQueue.main.async {
                self.imageView.image = nil
                self.titleLabel.text = currentProduct.title
                self.descriptionLabel.text = currentProduct.description
                
                //describing?
                let priceText = currentProduct.price != nil ? "\(currentProduct.price!)$" : "N/A"
                    self.priceLabel.text = priceText
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: URL(string: currentProduct.thumbnail)!), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.imageView.image = image }
                }
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        productLabel.text = "Product Info."
        fetchRemoteProduct()
        imageViewDesign()
        backgroundColor()
        tappedSaveProductButtonDesign()
        tappedSkipButtonDesign()
        tappedPresentWishListDesign()
    }
    
    
    @IBAction func tappedSkipButton(_ sender: Any) {
        self.fetchRemoteProduct() // 새로운 상품을 불러오는 함수 호출
    }
    
    @IBAction func tappedSaveProductButton(_ sender: Any) {
        self.saveWishProduct() // 상품을 저장
        
    }
    
    @IBAction func tappedPresentWishList(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "WishListViewController") as? WishListViewController else { return }
        
        self.present(nextVC, animated: true)
    }
    
    
    
    
    
    //이 함수는 데이터를 가져오는 용도로만 사용할 예정임으로 private func로
    private func fetchRemoteProduct() {
        
        let session = URLSession.shared
        
        //productID 설정
        let productID = Int.random(in: 1...100)
        
        //URL 생성
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            
            //URLSessionDataTask를 사용해 비동기적으로 데이터 요청
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.currentProduct = product
                        print("Received Data: \(product)")
                    } catch {
                        print("Decode Error: \(error)")
                        
                    }
                }
            }
            
            //네트워크 요청 시작
            task.resume()
        }
        
    }
    
    // currentProduct를 가져와 Core Data에 저장합니다.
    private func saveWishProduct() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        guard let currentProduct = self.currentProduct else { return }
        
        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = Double(currentProduct.price)
        
        try? context.save()
    }
    
    //MARK: - 디자인 요소 코드
    
    //버튼 디자인
    @IBOutlet weak var tappedSaveProductButton: UIButton!
    func tappedSaveProductButtonDesign() {
        tappedSaveProductButton.layer.cornerRadius = 15
    }
    
    @IBOutlet weak var tappedSkipButton: UIButton!
    func tappedSkipButtonDesign() {
        tappedSkipButton.layer.cornerRadius = 15
    }
    
    @IBOutlet weak var tappedPresentWishList: UIButton!
    func tappedPresentWishListDesign() {
        tappedPresentWishList.layer.cornerRadius = 15
    }
    
    //imageView 디자인
    func imageViewDesign() {
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowColor = UIColor.gray.cgColor
        //        imageView.clipsToBounds = false
        imageView.layer.masksToBounds = true
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: imageView.layer.cornerRadius).cgPath
    }
    
    //배경 컬러
    func backgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.systemGray3.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

