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

    var method: HTTPMethod {
        switch self {
        case .getProducts, .getProductsByIds:
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
        default:
            return nil
        }
    }

    var path: String {
        switch self {
        case .getProducts, .getProductsByIds:
            return "\(Support.apiVersion)\(ShopifyResource.products.endpoint)"
        default:
            return ""
        }
    }

    var authorizationHeader: HTTPHeaderField? {
        switch self {
        case .getProducts, .getProductsByIds:
            return .authorization
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .getProducts, .getProductsByIds:
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



