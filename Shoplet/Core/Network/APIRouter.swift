//
//  APIRouter.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation
import Alamofire


enum APIRouter: URLRequestConvertible {

    case getProducts
    case getProductsByIds(ids: [String])
    case getCollections
    case getPriceRules
    case getDiscountCodes(ruleId: String)
    case deleteProduct(productId: String)
    case deleteCollection(collectionId: String)
    case deletePriceRule(ruleId: String)
    case deleteDiscountCodes(ruleId: String, codeId: String)

    var method: HTTPMethod {
        switch self {
        case .getProducts, .getProductsByIds, .getCollections, .getPriceRules, .getDiscountCodes:
            return .get
        case .deleteProduct, .deletePriceRule, .deleteCollection, .deleteDiscountCodes:
            return .delete
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
        default:
            return nil
        }
    }

    var path: String {
        switch self {
        case .getProducts, .getProductsByIds:
            return ShopifyResource.products.endpoint
        default:
            return ""
        }
    }

    var authorizationHeader: HTTPHeaderField? {
        switch self {
        case .getProducts, .getProductsByIds, .getCollections, .getPriceRules, .getDiscountCodes, .deleteProduct, .deleteCollection, .deletePriceRule, .deleteDiscountCodes:
            return .authorization
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .getProducts, .getProductsByIds, .getCollections, .getPriceRules, .getDiscountCodes, .deleteProduct, .deleteCollection, .deletePriceRule, .deleteDiscountCodes:
            return .basic
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path + ".json"))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        if let headerField = authorizationHeader {
            urlRequest.setValue(authorizationType.headerValue(), forHTTPHeaderField: headerField.rawValue)
        }

        return try encoding.encode(urlRequest, with: parameters)
    }
}



