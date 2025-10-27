//
//  Client+Documents.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 02/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import Gloss

extension Client {
    func saveScan(store: ScanStore, completion: @escaping (Bool) -> Void) {
        guard let product = store.product, let image = store.image else {
            completion(false)
            return
        }

        var images = [image]
        images.append(contentsOf: store.extraImages)
        
        let request = Request.uploadScan(images: images, productId: product.userProductId)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)

        restClient.multipart(request: request) { (response) in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            
            guard let _ = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func uploadKidReceipt(store: ScanStore, completion: @escaping (Bool) -> Void) {
        guard  let benefitProductID = store.benefitProductID, let image = store.image ,let kidID = store.KidId else {
            completion(false)
            return
        }
        
        var images = [image]
        images.append(contentsOf: store.extraImages)
        
        let request = Request.uploadKidReceipt(images: images, productId: benefitProductID, userKidId: kidID)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)


        restClient.multipart(request: request) { (response) in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let _ = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func getDocuments(month: Int,
                      year: Int,
                      product: Product?,
                      completion: @escaping ([Document]) -> Void) {
        let request = Request.getDocuments(month: month, year: year, product: product)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    UIApplication.shared.show(error: error.localizedDescription)
                }
                completion([])
                return
            }
            
            let documents: [Document]? = "data" <~~ json
            completion(documents?.sorted { $0.date ?? Date() > $1.date ?? Date() } ?? [])

        }
    }
    
    func getDocumentsPendingCount(month: Int,
                      year: Int,
                      product: Product?,
                      completion: @escaping (Int) -> Void) {
        let request = Request.getDocumentsPendingCount(month: month, year: year, product: product)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(0)
                return
            }
            completion("data.pending_documents_count" <~~ json ?? 0)
        }
    }
    
    func getFirstDocumentUploadDate(completion: @escaping (Date?) -> Void) {
        let request = Request.getFirstDocumentUploadDate().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            
            guard let json = parsedResponse.0 else {
                completion(nil)
                return
            }
            
            guard var stringDate: String = "data" <~~ json else {
                completion(nil)
                return
            }
            
            if stringDate.count == 10 {
                // yyyy-MM-dd format. Apend time string
                stringDate += " 12:00:00"
            }
            
            let date = stringDate.toDate("yyyy-MM-dd HH:mm:ss")?.date
    
            completion(date)
        }
    }
}
