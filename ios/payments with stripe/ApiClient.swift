//
//  ApiClient.swift
//  payments with stripe
//
//  Created by Shivam Maggu on 01/02/23.
//

import Foundation

typealias PaymentIntentType = ((PaymentIntentDataModel? , Error?) -> Void)

protocol IApiClient {
    func createPaymentIntent(cartContent: [String: Any], completion: @escaping PaymentIntentType)
}

class ApiClient: IApiClient {
    
    static private let backendURL = URL(string: "http://127.0.0.1:4242")
    
    init() {}
    
    func createPaymentIntent(cartContent: [String: Any], completion: @escaping PaymentIntentType) {
        
        guard let baseURL = Self.backendURL else { return }
        
        let url: URL = baseURL.appendingPathComponent("/create-payment-intent")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: cartContent)
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                        
            guard error == nil else {
                print(error.debugDescription)
                completion(nil, error)
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data
            else {
                let error = NSError(domain: "Failed to decode response from server.", code: -9001)
                completion(nil, error)
                return
            }
            
            let intentObject = try? JSONDecoder().decode(PaymentIntentDataModel.self, from: data)
            completion(intentObject, nil)
        })
                                              
        task.resume()
    }
}
