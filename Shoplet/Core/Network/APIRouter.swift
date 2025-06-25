//
//  APIRouter.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation
import Alamofire


enum APIRouter: URLRequestConvertible {
    
    //1
    case getProducts
    case getProductsByIds(ids: [String])
    case getPopularProducts
    case getBrands
    case priceRules
    case getPriceRule(priceRule: Int)
    case coupons(id : Int)
    case createDraftOrder(draftOrder : DraftOrderItem)
    case updateDraftOrder(draftOrder : DraftOrderItem, dtaftOrderId: Int)
    case getDraftOrderById(draftOrderId: Int)
    case deleteDraftOrder(draftOrderId: Int)
    case createCustomer(customer: CustomerRequest)
    case getCustomerById(id: Int)
    case getAllCustomers
    case getAllDraftOrders
    case updateCustomer(customer: CustomerRequest, customerId: Int)
    case getAddress(customerId: Int, addressId: Int)
    case updateAddress(addressId: Int, address: AddressRequest, customerId: Int)
    case createAddress(address: AddressRequest, customerId: Int)
    case getuserAddresses(customerId: Int)
    case markAddressDefault(customerId: Int, addressId: Int)
    case deleteAddress(customerId: Int, addressId: Int)
    case completeOrder(draftOrderId: Int)
    case getAllOrders

    var method: HTTPMethod {
        switch self {
        case .getProducts, .getProductsByIds , .getPopularProducts, .getBrands, .priceRules, .coupons, .getDraftOrderById,.getCustomerById, .getAllCustomers, .getPriceRule, .getAllDraftOrders,.getAddress, .getuserAddresses:
            return .get
        case .createDraftOrder, .createCustomer, .createAddress:
            return .post
        case .updateDraftOrder, .updateCustomer, .updateAddress, .markAddressDefault, .completeOrder:
            return .put
        case .deleteDraftOrder, .deleteAddress:
            return .delete
        case .getAllOrders: return .get

        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .createDraftOrder, .updateDraftOrder,.createCustomer, .updateCustomer, .createAddress, .updateAddress:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getProducts,.getPopularProducts, .getBrands, .priceRules, .coupons, .getDraftOrderById, .deleteDraftOrder, .getAllCustomers, .getCustomerById, .getPriceRule, .getAllDraftOrders,  .getAddress, .getuserAddresses, .markAddressDefault, .deleteAddress, .completeOrder:
            return nil
        case .getProductsByIds(let ids):
            return ["ids": ids.joined(separator: ",")]
        case .createDraftOrder(let draftOrder):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(draftOrder)) as? [String : Any]
        case .updateDraftOrder(let draftOrder, _):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(draftOrder)) as? [String : Any]
        case .createCustomer(let customer), .updateCustomer(let customer, _):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(customer)) as? [String: Any]
        case .createAddress(let address, _), .updateAddress(_, let address, _):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(address)) as? [String: Any]
            
        case .getAllOrders:
            return ["status": "any"]

        }
    }
    
    var path: String {
        switch self {
        case .getProducts, .getProductsByIds,.getPopularProducts:
            return "\(Support.apiVersion)\(ShopifyResource.products.endpoint)"
            
        case .getBrands:
            return "\(Support.apiVersion)\(ShopifyResource.smartCollections.endpoint)"
            
        case .priceRules:
            return "\(Support.apiVersion)\(ShopifyResource.priceRules.endpoint)"
        case .getPriceRule(let priceRule):
            return "\(Support.apiVersion)\(ShopifyResource.priceRules.endpoint)/\(priceRule)"
        case .coupons(let priceRuleId):
            return "\(Support.apiVersion)price_rules/\(priceRuleId)/\(ShopifyResource.discounts.endpoint)"
        case .createDraftOrder, .getAllDraftOrders:
            return "\(Support.apiVersion)\(ShopifyResource.createDraftOrder.endpoint)"
        case .updateDraftOrder(_, let draftOrderId), .getDraftOrderById(let draftOrderId),.deleteDraftOrder(let draftOrderId):
            return "\(Support.apiVersion)\(ShopifyResource.updateDraftOrder.endpoint)/\(draftOrderId)"
            
        case .createCustomer(customer: _):
            return "\(Support.apiVersion)customers"
        case .getCustomerById(id: let id):
            return "\(Support.apiVersion)customers/\(id)"
        case .getAllCustomers:
            return "\(Support.apiVersion)customers"
        case .updateCustomer(_, let customerId):
            return "\(Support.apiVersion)\(ShopifyResource.customers)/\(customerId)"
        case .getuserAddresses(let customerId), .createAddress(_, let customerId):
            return "\(Support.apiVersion)\(ShopifyResource.customers.endpoint)/\(customerId)/\(ShopifyResource.getAddress.endpoint)"
        case .updateAddress(let addressId, _, let customerId), .getAddress(let customerId, let addressId), .deleteAddress(let customerId, let addressId):
            return "\(Support.apiVersion)\(ShopifyResource.customers.endpoint)/\(customerId)/\(ShopifyResource.getAddress.endpoint)/\(addressId)"
        case .markAddressDefault(let customerId, let addressId):
            
            return "\(Support.apiVersion)\(ShopifyResource.customers.endpoint)/\(customerId)/\(ShopifyResource.getAddress.endpoint)/\(addressId)/\(ShopifyResource.markAddressDefault.endpoint)"
        case .completeOrder(let draftOrderId):
            return "\(Support.apiVersion)\(ShopifyResource.createDraftOrder.endpoint)/\(draftOrderId)/\(ShopifyResource.completOrder.endpoint)"
        case .getAllOrders: return "\(Support.apiVersion)orders"


        }
    }
    
    var authorizationHeader: HTTPHeaderField? {
        switch self {
        case .getProducts, .getProductsByIds,.getPopularProducts,.getBrands, .priceRules, .coupons, .getDraftOrderById, .deleteDraftOrder, .getAllCustomers, .getPriceRule, .getAllDraftOrders,  .getuserAddresses, .getAddress, .markAddressDefault, .deleteAddress,.getAllOrders, .completeOrder:
            return .authorization
        case .createDraftOrder, .updateDraftOrder, .createCustomer,.getCustomerById, .updateCustomer,
                .createAddress, .updateAddress:
            return .password
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .getProducts, .getProductsByIds,.getPopularProducts,.getBrands, .priceRules, .coupons, .getDraftOrderById, .deleteDraftOrder, .getPriceRule, .getAllDraftOrders, .getuserAddresses, .getAddress, .markAddressDefault, .deleteAddress, .getAllOrders,.completeOrder:
            return .basic
        case .createDraftOrder, .updateDraftOrder, .createCustomer, .getCustomerById, .getAllCustomers, .updateCustomer, .createAddress, .updateAddress:
            return .apiKey
            
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try Constants.baseUrl.asURL()
        
        switch self {
        case .getProductsByIds:
            url.appendPathComponent(ShopifyResource.products.endpoint)
        default:
            url.appendPathComponent(path + ".json")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if let headerField = authorizationHeader {
            urlRequest.setValue(authorizationType.headerValue(), forHTTPHeaderField: headerField.rawValue)
        }
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}




