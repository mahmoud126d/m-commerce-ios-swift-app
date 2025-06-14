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
        case .getProducts, .getProductsByIds, .getPopularProducts, .getBrands, .priceRules, .coupons, .getCustomerById, .getAllCustomers,.getDraftOrderById:
            return .get
        case .createCustomer,.createDraftOrder:
            return .post
        case .updateDraftOrder:
            return .put
        case .deleteDraftOrder:
            return .delete
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .createCustomer, .createDraftOrder, .updateDraftOrder:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getProducts,.getPopularProducts, .getBrands, .priceRules, .coupons,.getCustomerById, .getAllCustomers, .coupons, .getDraftOrderById, .deleteDraftOrder:
            return nil
        case .getProductsByIds(let ids):
            return ["ids": ids.joined(separator: ",")]
        case .createCustomer(let customer):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(customer)) as? [String: Any]
        case .createDraftOrder(let draftOrder):
                   return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(draftOrder)) as? [String : Any]
               case .updateDraftOrder(let draftOrder, _):
                   return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(draftOrder)) as? [String : Any]
        }
    }

    var path: String {
        switch self {
        case .createCustomer:
            return "\(Support.apiVersion)customers"
        case .getProducts, .getProductsByIds,.getPopularProducts:
            return "\(Support.apiVersion)\(ShopifyResource.products.endpoint)"

           case .getBrands:
            return "\(Support.apiVersion)\(ShopifyResource.smartCollections.endpoint)"
            
        case .priceRules:
            return "\(Support.apiVersion)\(ShopifyResource.priceRules.endpoint)"
            
        case .coupons(let priceRuleId):
            return "\(Support.apiVersion)price_rules/\(priceRuleId)/\(ShopifyResource.discounts.endpoint)"
            
        case .getCustomerById(let id):
            return "\(Support.apiVersion)customers/\(id)"
            
        case .getAllCustomers:
                return "\(Support.apiVersion)customers"
            
        case .createDraftOrder:
                    return "\(Support.apiVersion)\(ShopifyResource.createDraftOrder.endpoint)"
                case .updateDraftOrder(_, let draftOrderId), .getDraftOrderById(let draftOrderId),.deleteDraftOrder(let draftOrderId):
                    return "\(Support.apiVersion)\(ShopifyResource.updateDraftOrder.endpoint)/\(draftOrderId)"

     
        }
    }

    var authorizationHeader: HTTPHeaderField? {
        switch self {
        case .getProducts, .getProductsByIds,.getPopularProducts,.getBrands, .priceRules, .coupons, .getAllCustomers, .getDraftOrderById, .deleteDraftOrder:
            return .authorization
        case .createCustomer,.getCustomerById, .createDraftOrder, .updateDraftOrder:
            return .shopifyAccessToken
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .createCustomer, .getCustomerById, .getAllCustomers ,.createDraftOrder, .updateDraftOrder:
            return .apiKey
        default:
            return .basic
        }
    }


    func asURLRequest() throws -> URLRequest {
        var url = try Constants.baseUrl.asURL()
        url.appendPathComponent(path + ".json")

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        let (headerField, headerValue) = authorizationType.header(for: .authorization)
        urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)

        switch self {
        case .createCustomer(let body):
            urlRequest.httpBody = try JSONEncoder().encode(body)
            return urlRequest
        default:
            return try encoding.encode(urlRequest, with: parameters)
        }
    }


}




