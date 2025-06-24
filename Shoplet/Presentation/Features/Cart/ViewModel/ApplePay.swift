//
//  ApplePay.swift
//  Shoplet
//
//  Created by Macos on 22/06/2025.
//

import Foundation
import PassKit

class ApplePay: NSObject, PKPaymentAuthorizationControllerDelegate{
    let draftOrder: DraftOrder
 //   var onSuccess: (() -> Void)? // ✅ Add this callback

    init(draftOrder: DraftOrder) {
        self.draftOrder = draftOrder
        super.init()
    }
    func startPayment(draftOrder: DraftOrder){
        var paymentSummary = [PKPaymentSummaryItem]()
        var paymentController :PKPaymentAuthorizationController?
        
        draftOrder.line_items?.forEach({ lineItem in
            let amount = Double((Double(lineItem.price ?? "1.0") ?? 1.0) * (Double(UserDefaultManager.shared.currencyRate ?? "1.0") ?? 1.0))
            
            paymentSummary.append(PKPaymentSummaryItem(label: lineItem.name ?? "", amount: NSDecimalNumber(value: amount)))
        })
        
        let totalPtice = Double((Double(draftOrder.total_price ?? "1.0") ?? 1.0) * (Double(UserDefaultManager.shared.currencyRate ?? "1.0") ?? 1.0))
        paymentSummary.append(PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: totalPtice)))
        
        let request = PKPaymentRequest()
        request.countryCode = "EG"
        request.currencyCode = UserDefaultManager.shared.currency ?? "USD"
        request.supportedNetworks = [.visa, .masterCard, .quicPay]
        request.merchantIdentifier = "merchant.com.shoplet.pay"
        request.shippingMethods = shippingMethodCalculator()
        request.merchantCapabilities = .capability3DS
        request.paymentSummaryItems = paymentSummary
        request.shippingType = .delivery
        let contact = PKContact()
         var name = PersonNameComponents()
        name.givenName = draftOrder.customer?.first_name
        name.familyName = draftOrder.customer?.last_name
        contact.name = name
        contact.phoneNumber = CNPhoneNumber(stringValue: draftOrder.customer?.phone ?? "")
        request.shippingContact = contact
                
        request.requiredShippingContactFields = [.name, .phoneNumber]
        paymentController = PKPaymentAuthorizationController(paymentRequest: request)
        paymentController?.delegate = self
        paymentController?.present()
    }
    
    func shippingMethodCalculator() -> [PKShippingMethod] {
           let today = Date()
           let calendar = Calendar.current
           let shippingStart = calendar.date(byAdding: .day, value: 5, to: today)
           let shippingEnd = calendar.date(byAdding: .day, value: 10, to: today)
           
           if let shippingEnd = shippingEnd, let shippingStart = shippingStart {
               let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
               let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
               let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.0"))
               shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
               shippingDelivery.detail = "We hope you enjoy our service"
               shippingDelivery.identifier = "DELIVERY"
               return [shippingDelivery]
           }
           return []
       }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment) async -> PKPaymentAuthorizationResult {
        print("Completed")
        return .init(status: .success, errors: nil)
    }
     
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss{
            print("apple pay finish")
        }
    }
    
    
    
}
