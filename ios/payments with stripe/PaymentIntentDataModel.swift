//
//  PaymentIntentDataModel.swift
//  payments with stripe
//
//  Created by Shivam Maggu on 01/02/23.
//

import Foundation

struct PaymentIntentDataModel: Decodable {
    let customerId: String
    let ephemeralKey: String
    let paymentIntent: String
    let publishableKey: String
}
