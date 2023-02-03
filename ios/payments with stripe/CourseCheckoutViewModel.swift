//
//  CourseCheckoutViewModel.swift
//  payments with stripe
//
//  Created by Shivam Maggu on 01/02/23.
//

import Foundation
import Stripe

class CourseCheckoutViewModel {
    
    private let apiClient: IApiClient
    private var paymentIntentClientSecret: String?
    private var customer: PaymentSheet.CustomerConfiguration?
    
    init(apiClient: IApiClient) {
        self.apiClient = apiClient
    }
    
    func fetchPaymentIntent(completion: @escaping ((Bool, String?) -> Void)) {
        
        let cartContent: [String: Any] = ["items": [["id": UUID().uuidString]]]
        
        self.apiClient.createPaymentIntent(cartContent: cartContent) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard error == nil else {
                print(error.debugDescription)
                completion(false, error.debugDescription)
                return
            }
            
            guard
                let customerId = data?.customerId as? String,
                let customerEphemeralKeySecret = data?.ephemeralKey as? String,
                let paymentIntentClientSecret = data?.paymentIntent as? String,
                let publishableKey = data?.publishableKey as? String
            else {
                let error = "Error fetching required data"
                print(error)
                completion(false, error)
                return
            }
            
            print("Created Payment Intent")
            
            self.setPublishableKey(publishableKey: publishableKey)
            self.paymentIntentClientSecret = paymentIntentClientSecret
            self.customer = .init(id: customerId,
                                  ephemeralKeySecret: customerEphemeralKeySecret)
            completion(true, nil)
        }
    }
    
    private func setPublishableKey(publishableKey: String) {
        STPAPIClient.shared.publishableKey = publishableKey
    }
    
    func getCustomer() -> PaymentSheet.CustomerConfiguration? {
        return self.customer
    }
    
    func getPaymentIntentClientSecret() -> String? {
        return self.paymentIntentClientSecret
    }
}
