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
    case createCustomer(customer: CustomerRequest)
    case getCustomerById(id: Int)
    case getAllCustomers


    var method: HTTPMethod {
        switch self {
        case .getProducts, .getProductsByIds , .getPopularProducts, .getBrands, .priceRules, .coupons, .getCustomerById, .getAllCustomers:
            return .get
        case .createCustomer:
            return .post
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .createCustomer:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getProducts,.getPopularProducts, .getBrands, .priceRules, .coupons,.getCustomerById, .getAllCustomers:
            return nil
        case .getProductsByIds(let ids):
            return ["ids": ids.joined(separator: ",")]
        case .createCustomer(let customer):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(customer)) as? [String: Any]
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
     
        }
    }

    var authorizationHeader: HTTPHeaderField? {
        switch self {
        case .getProducts, .getProductsByIds,.getPopularProducts,.getBrands, .priceRules, .coupons, .getAllCustomers:
            return .authorization
        case .createCustomer,.getCustomerById:
            return .shopifyAccessToken
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .createCustomer, .getCustomerById, .getAllCustomers:
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




