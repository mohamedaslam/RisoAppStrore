//
//  RESTClient.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Alamofire
import Gloss

final class RESTClient {
    // MARK: - Middleware
    private var currentNumberOfRequests: Int = 0
    
    private func requestStarted() {
        currentNumberOfRequests += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = currentNumberOfRequests > 0
    }
    
    private func requestEnded() {
        currentNumberOfRequests = max(0, currentNumberOfRequests - 1)
        UIApplication.shared.isNetworkActivityIndicatorVisible = currentNumberOfRequests > 0
    }
    
    init() {
        
    }
    
//    func request(_ request: Request,
//                 method: HTTPMethod = .get,
//                 parameters: Parameters? = nil,
//                 encoding: ParameterEncoding = URLEncoding.default,
//                 headers: HTTPHeaders? = nil,
//                 completion: @escaping (DataResponse<Any>) -> Void) {
//        requestStarted()
//        Alamofire.request(
//            request.makeRoutable(),
//            method: method,
//            parameters: parameters,
//            encoding: encoding,
//            headers: headers
//            ).responseJSON { response in
//                self.requestEnded()
//                completion(response)
//        }
//    }
    
    @discardableResult
    func request(_ request: Request, completion: @escaping (DataResponse<Any>) -> Void) -> DataRequest {
        requestStarted()
        return Alamofire.request(request.makeRoutable()).responseJSON { response in
            self.requestEnded()
            completion(response)
        }
    }
    
    func multipart(request: Request, completion: @escaping (DataResponse<Any>) -> Void) {
        let router = request.makeRoutable()
        Alamofire.upload(multipartFormData: { (formData) in
            // This will only parse first level parameters. We should add
            // support for nested parameters also
            let parameters = router.request.route.parameters
            for (key, value) in parameters {
                if
                    let image = value as? UIImage,
                    let imageData = image.wxCompress() {
                    print("Image size: \(imageData.count / 1024) KB")
                    formData.append(
                        imageData,
                        withName: "\(key)",
                        fileName: "\(Date().timeIntervalSince1970).jpeg",
                        mimeType: "image/jpg"
                    )
                }
                else if let images = value as? [UIImage] {
                    for (index, image) in images.enumerated() {
                        if let imageData = image.wxCompress() {
                            print("Image size: \(imageData.count / 1024) KB")
                            formData.append(
                                imageData,
                                withName: "\(key)[\(index)]",
                                fileName: "\(Date().timeIntervalSince1970).jpeg",
                                mimeType: "image/jpg"
                            )
                        }
                    }
                }
                else if
                    let text = value as? String,
                    let textData = text.data(using: .utf8) {
                    formData.append(textData, withName: key)
                }
                else if
                    let textData = String(describing: value).data(using: .utf8) {
                    formData.append(textData, withName: key)
                }
            }
        }, to: router.request.url + router.request.route.endpoint,
           method: router.request.route.method,
           headers: router.urlRequest?.allHTTPHeaderFields ?? [:]) { (encodingResult) in
            
            switch encodingResult {
            case .success(let request, _, _):
                self.requestStarted()
                request.responseJSON { response in
                    self.requestEnded()
                    completion(response)
                }
            case .failure(let error):
                let response = DataResponse<Any>(
                    request: router.urlRequest,
                    response: nil,
                    data: nil,
                    result: .failure(error)
                )
                completion(response)
                break
            }
        }
    }
}

typealias JSONParsedResponse      = ([String : Any]?, Error?)
typealias JSONArrayParsedResponse = ([String : Any]?, Error?)

class ResponseParser {
    class func parse<T>(_ response: DataResponse<Any>) -> (T?, Error?) {
        switch response.result {
        case .success(let value):
            var error: Error?
            if let json = value as? [String : Any] {
                if let apiError = APIError(json: json) {
                    error = apiError
                    return (nil, error)
                } else if let errors: [APIError] = "errors" <~~ json {
                    error = errors.first
                    return (nil, error)
                }
            }
            guard let json = value as? T else {
                return (nil, error)
            }
            return (json, error)
        case .failure(let error):
            print("\n\n===========Error===========")
            print("Error Code: \(error._code)")
            print("Error Messsage: \(error.localizedDescription)")
            if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                print("Server Error: " + str)
            }
            debugPrint(error as Any)
            print("===========================\n\n")
            return (nil, error)
        }
    }
}

/*
 {
 "error": "invalid_credentials",
 "message": "The user credentials were incorrect."
 }
 
 */

struct APIError: LocalizedError {
    let error: String
    let message: String
    
    var errorDescription: String? {
        return message
    }
}

extension APIError: JSONDecodable {
    init?(json: JSON) {
        guard
            let error: String = "error" <~~ json,
            let message: String = "message" <~~ json else {
                
                guard
                    let error: String = "internalMessage" <~~ json,
                    let message: Any = "userMessage" <~~ json else {
                        return nil
                }
                
                self.error = error
                self.message = String(describing: message)
                return
        }
        
        self.error   = error
        self.message = message
    }
}
