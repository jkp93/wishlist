//
//  JSON.swift
//  WishList
//
//  Created by 박중권 on 4/12/24.
//

//{
//    "id": 1,
//    "title": "iPhone 9",
//    "description": "An apple mobile which is nothing like apple",
//    "price": 549,
//    "discountPercentage": 12.96,
//    "rating": 4.69,
//    "stock": 94,
//    "brand": "Apple",
//    "category": "smartphones",
//    "thumbnail": "https://i.dummyjson.com/data/products/1/thumbnail.jpg",
//    "images": [
//        "https://i.dummyjson.com/data/products/1/1.jpg",
//        "https://i.dummyjson.com/data/products/1/2.jpg",
//        "https://i.dummyjson.com/data/products/1/3.jpg",
//        "https://i.dummyjson.com/data/products/1/4.jpg",
//        "https://i.dummyjson.com/data/products/1/thumbnail.jpg"
//    ]
//}

import Foundation

struct RemoteProduct: Codable {
    
    let id: Int!
    let title: String!
    let description: String!
    let price: Int!
    let thumbnail: String!
    let images: [String]
    
}
