//
//  NetworkManagerTest.swift
//  ShopletTests
//
//  Created by Macos on 26/06/2025.
//

import XCTest

@testable import Shoplet

final class NetworkManagerTest: XCTestCase{
    
    override func setUp() {}
    
    override func tearDown() {}
    
    func testGetPriceRules_returnNotNil(){
        let expectation = expectation(description: "Loading Price Rules")
        APIClient.getPriceRules { res in
            switch res{
            case .success(let priceRule):
                XCTAssertNotNil(priceRule.price_rules)
                XCTAssertTrue(priceRule.price_rules.count >= 0)
            case .failure(let error):
                XCTFail("Error.... : \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testCoupons_returnNotNil(){
        let expectation = expectation(description: "Loading Copons")
        APIClient.getCoupons(id: 1415553614042) { res in
            switch res{
            case .success(let copuns):
                XCTAssertNotNil(copuns.discount_codes)
                XCTAssertTrue(copuns.discount_codes.count >= 0)
            case .failure(let error):
                XCTFail("Error.... : \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    
    func testCreateDraftOrderFailure(){
        let expectation = expectation(description: "Uploading Draft Order")
        let draft_order = DraftOrderItem(draft_order: DraftOrder(id:-1,line_items: [
            LineItem(price:"500", quantity: 1,title: "Test")
        ],shipping_line: nil,subtotal_price: "5000"))
        APIClient.createDraftOrder(draftOrder: draft_order) { res in
            switch res{
            case .success(_):
                XCTFail("Expect Fail")
            case .failure(_):
                expectation.fulfill()
            }
            
        }
        waitForExpectations(timeout: 5)
        
    }
    
    func testUpdateDraftOrderFailure(){
        let expectation = expectation(description: "Updating Draft Order")
        let draft_order = DraftOrderItem(draft_order: DraftOrder(line_items: [
            LineItem(price:"500", quantity: 2,title: "Test")
        ],shipping_line: nil,subtotal_price: "5000"))
        APIClient.updateDraftOrder(draftOrder: draft_order, dtaftOrderId: 1) { res in
            switch res{
            case .success(_):
                XCTFail("Error")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            
        }
        waitForExpectations(timeout: 5)
        
    }
    
    
    func testGetAllCustomers_returnNotNil(){
        let expectation = expectation(description: "Loading Customer")
        APIClient.getAllCustomers { res in
            switch res{
            case .success(let customers):
                XCTAssertNotNil(customers.customers)
            case .failure(let error):
                XCTFail("Error.... : \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetPriceRuleById_returnNotNil(){
        let expectation = expectation(description: "Loading PriceRule")
        APIClient.getPriceRulesById(priceRuleId: 1415553614042) { res in
            switch res{
            case .success(let priceRule):
                XCTAssertNotNil(priceRule.price_rule)
            case .failure(let error):
                XCTFail("Error.... : \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetDraftOrderById(){
        let expectation = expectation(description: "Loading Draft Order")
        APIClient.getDraftOrderById(dtaftOrderId: 1) { res in
            switch res{
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    func testGetCurrencies_returnNotNil(){
        let expectation = expectation(description: "Loading Currency")
        APIClient.getCurrencies { res in
            switch res{
            case .success(let currencies):
                XCTAssertNotNil(currencies.rates)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetEgyptCities(){
        let expectation = expectation(description: "Loading Cities")
        APIClient.getEgyptCities { res in
            switch res{
            case .success(let cities):
                XCTAssertNotNil(cities.data)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetProductById(){
        let expectation = expectation(description: "Loading Product")
        APIClient.getProductsByIds(ids: ["8875058036954"]) { res in
            switch res{
            case .success(let product):
                XCTAssertNotNil(product.products.first)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()

        }
        waitForExpectations(timeout: 10)
    }
    
    func testDeleteDraftOrder(){
        let expectation = expectation(description: "Deleting Draft Order")
        APIClient.deleteDraftOrder(dtaftOrderId: 1) { res in
            switch res{
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    func testCompleteOrder(){
        let expectation = expectation(description: "Complete Draft Order")
        APIClient.completeOrder(draftOrderId: 1) { res in
            switch res{
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testCreateCustomer() {
        let expectation = expectation(description: "Create Customer ")
        
        let custmer = Customer(
            id: 1,
            email: "email@gmail.com",
            created_at: nil,
            updated_at: nil,
            first_name: "test1",
            last_name: nil,
            orders_count: nil,
            state: nil,
            total_spent: nil,
            last_order_id: nil,
            note: nil,
            verified_email: nil,
            multipass_identifier: nil,
            tax_exempt: nil,
            tags: nil,
            last_order_name: nil,
            currency: nil,
            phone: nil,
            addresses: nil,
            tax_exemptions: nil,
            email_marketing_consent: nil,
            sms_marketing_consent: nil,
            admin_graphql_api_id: nil,
            default_address: nil,
            password: nil,
            password_confirmation: nil
        )
        APIClient.createCustomer(customer: CustomerRequest(customer: custmer)) { res in
            switch res {
            case .success(let response):
                XCTAssertEqual(response.customer?.id, 1)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (Shoplet.NetworkError error 0.)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        
    }
    
    func testUpdateCustomer() {
        let expectation = expectation(description: "Update Customer ")
        
        let custmer = Customer(
            id: 1,
            email: "email@gmail.com",
            created_at: nil,
            updated_at: nil,
            first_name: "test",
            last_name: nil,
            orders_count: nil,
            state: nil,
            total_spent: nil,
            last_order_id: nil,
            note: nil,
            verified_email: nil,
            multipass_identifier: nil,
            tax_exempt: nil,
            tags: nil,
            last_order_name: nil,
            currency: nil,
            phone: nil,
            addresses: nil,
            tax_exemptions: nil,
            email_marketing_consent: nil,
            sms_marketing_consent: nil,
            admin_graphql_api_id: nil,
            default_address: nil,
            password: nil,
            password_confirmation: nil
        )
        APIClient.updateCustomer(customerId: 1, customer: CustomerRequest(customer: custmer)) { res in
            switch res {
            case .success(let response):
                XCTAssertEqual(response.customer?.id, 1)
             case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (Shoplet.NetworkError error 0.)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        
    }
    
    func testCreateAddress() {
        let expectation = expectation(description: "Create Address")

        let address = AddressDetails(
            id: 1,
            customer_id: 1,
            first_name: "test",
            last_name: nil,
            company: nil,
            address1: "Test st",
            address2: nil,
            city: nil,
            province: nil,
            country: nil,
            zip: nil,
            phone: "20123456789",
            name: nil,
            province_code: nil,
            country_code: nil,
            country_name: nil,
            `default`: nil
        )

        APIClient.createAddress(address: AddressRequest(customer_address: address), customerId: 1) { res in
            switch res {
            case .success(let response):
                XCTAssertEqual(response.customer_address?.address1, "Test st")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (Shoplet.NetworkError error 0.)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testDeleteAddress() {
        let expectation = expectation(description: "Deleting Address")

        let address = AddressDetails(
            id: 1,
            customer_id: 1,
            first_name: "test",
            last_name: nil,
            company: nil,
            address1: "Test st",
            address2: nil,
            city: nil,
            province: nil,
            country: nil,
            zip: nil,
            phone: "20123456789",
            name: nil,
            province_code: nil,
            country_code: nil,
            country_name: nil,
            `default`: nil
        )

        APIClient.deleteAddresse(customerId: 1, addressId: 1) { res in
            switch res {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (Shoplet.NetworkError error 0.)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
    func testGetUserAddress(){
        let expectation = expectation(description: "Load user's address")
        APIClient.getUserAddresses(customerId: 1) { res in
            switch res{
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testMarkAddressDefault(){
        let expectation = expectation(description: "Mark Address Default")
        APIClient.markAddresseDefault(customerId: 1, addressId: 1){ res in
            switch res{
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    /*func testCitiesWithNoNetwork(){
        AppCommon.shared.isNetwork = false
        let expectation = expectation(description: "Loading Cities No Network")
        APIClient.getEgyptCities { res in
            switch res{
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkUnreachable)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }*/
    
    func testGetAllProducts(){
        let expectation = expectation(description: "Loading Products")
        APIClient.getProducts { res in
            switch res{
            case .success(let res):
                XCTAssertNotNil(res)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testOrders(){
        APIClient().fetchAllOrders { res in
            switch res{
                case .success(let res):
                    XCTAssertNotNil(res)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

