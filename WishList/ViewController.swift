//
//  ViewController.swift
//  WishList
//
//  Created by 박중권 on 4/12/24.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        let user = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.currentProduct = product //코어데이터 생성 전이라 오류
                    } catch {
                        print("Decode Error: \(error)")
                        
                    }
                }
            }
            
            //네트워크 요청 시작
            task.resume()
        }
        
    }

}

