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
    case coupons(id : Int)
    case createDraftOrder(draftOrder : DraftOrderItem)
    case updateDraftOrder(draftOrder : DraftOrderItem, dtaftOrderId: Int)
    case getDraftOrderById(draftOrderId: Int)
    case deleteDraftOrder(draftOrderId: Int)
    case createCustomer(customer: CustomerRequest)
    case getCustomerById(id: Int)
    case getAllCustomers

    var method: HTTPMethod {
        switch self {
        case .getProducts, .getProductsByIds , .getPopularProducts, .getBrands, .priceRules, .coupons, .getDraftOrderById,.getCustomerById, .getAllCustomers:
            return .get
        case .createDraftOrder, .createCustomer:
            return .post
        case .updateDraftOrder:
            return .put
        case .deleteDraftOrder:
            return .delete
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .createDraftOrder, .updateDraftOrder,.createCustomer:
                return JSONEncoding.default
            default:
                return URLEncoding.default
            }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getProducts,.getPopularProducts, .getBrands, .priceRules, .coupons, .getDraftOrderById, .deleteDraftOrder, .getAllCustomers, .getCustomerById:
            return nil
        case .getProductsByIds(let ids):
            return ["ids": ids.joined(separator: ",")]
        case .createDraftOrder(let draftOrder):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(draftOrder)) as? [String : Any]
        case .updateDraftOrder(let draftOrder, _):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(draftOrder)) as? [String : Any]
        case .createCustomer(let customer):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(customer)) as? [String: Any]

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
            
        case .coupons(let priceRuleId):
            return "\(Support.apiVersion)price_rules/\(priceRuleId)/\(ShopifyResource.discounts.endpoint)"
        case .createDraftOrder:
            return "\(Support.apiVersion)\(ShopifyResource.createDraftOrder.endpoint)"
        case .updateDraftOrder(_, let draftOrderId), .getDraftOrderById(let draftOrderId),.deleteDraftOrder(let draftOrderId):
            return "\(Support.apiVersion)\(ShopifyResource.updateDraftOrder.endpoint)/\(draftOrderId)"
            
            

        case .createCustomer(customer: let customer):
            return "\(Support.apiVersion)customers"
        case .getCustomerById(id: let id):
            return "\(Support.apiVersion)customers/\(id)"
        case .getAllCustomers:
            return "\(Support.apiVersion)customers"

        }
    }

    var authorizationHeader: HTTPHeaderField? {
        switch self {
        case .getProducts, .getProductsByIds,.getPopularProducts,.getBrands, .priceRules, .coupons, .getDraftOrderById, .deleteDraftOrder, .getAllCustomers:
            return .authorization
        case .createDraftOrder, .updateDraftOrder, .createCustomer,.getCustomerById:
            return .password
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .getProducts, .getProductsByIds,.getPopularProducts,.getBrands, .priceRules, .coupons, .getDraftOrderById, .deleteDraftOrder:
            return .basic
        case .createDraftOrder, .updateDraftOrder, .createCustomer, .getCustomerById, .getAllCustomers:
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




