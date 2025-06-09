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
    case priceRules
    case coupons(id : Int)

    var method: HTTPMethod {
        switch self {
        case .getProducts, .getProductsByIds, .priceRules, .coupons:
            return .get
        }
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }

    var parameters: [String: Any]? {
        switch self {
        case .getProducts:
            return nil
        case .getProductsByIds(let ids):
            return ["ids": ids.joined(separator: ",")]
        case .priceRules:
            return nil
        case .coupons:
            return nil
        }
    }

    var path: String {
        switch self {
        case .getProducts, .getProductsByIds:
            return "\(Support.apiVersion)\(ShopifyResource.products.endpoint)"
        case .priceRules:
            return "\(Support.apiVersion)\(ShopifyResource.priceRules.endpoint)"
        case .coupons(let priceRuleId):
            return "\(Support.apiVersion)price_rules/\(priceRuleId)/\(ShopifyResource.discounts.endpoint)"
        default:
            return ""
        }
    }

    var authorizationHeader: HTTPHeaderField? {
        switch self {
        case .getProducts, .getProductsByIds, .priceRules, .coupons:
            return .authorization
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .getProducts, .getProductsByIds, .priceRules, .coupons:
            return .basic
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



