//
//  AddAddress.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import SwiftUI
import MapKit
struct AddAddress: View {
    @State private var address = ""
    @State private var city = ""
    @State private var country = "Egypt"
    @State private var zip = ""
    @StateObject var locationViewMode: LocationViewModel = LocationViewModel()
    @StateObject var addressViewModel: AddressViewModel = AddressViewModel()
    @State var selectedLocation: CLLocationCoordinate2D?
    @State var showCities = false
    var onSaved: (_ address: AddressRequest)->Void
    
    var body: some View {
        VStack{
            Text("Add New Address")
                .font(.headline)
                .bold()
            Spacer()
            ScrollView(showsIndicators: false){
                VStack{
                    Spacer()
                    HStack{
                        Toggle(isOn: $locationViewMode.isLocationEnabled) {
                            Text("use Loaction ? ")
                        }
                    }.padding()
                    MapRegion(region: $locationViewMode.region, isEnable: locationViewMode.isLocationEnabled, pinCoordinate: selectedLocation){
                        coordinates in
                        selectedLocation = coordinates
                        locationViewMode.region.center = coordinates
                        reverseGeocode(coordinate: coordinates)
                    }
                    .frame(height: 300)
                    .padding(.bottom)
                    
                    if locationViewMode.isLocationEnabled{
                        CustomTextField(placeholder: "Enter Address", text: $locationViewMode.address)
                        CustomTextField(placeholder: "Enter City", text: $locationViewMode.city)
                        CustomTextField(placeholder: "Enter Country", text: $locationViewMode.country)
                            .disabled(true)
                        CustomTextField(placeholder: "Enter Zip code", text: $zip)
                    }else{
                        CustomTextField(placeholder: "Enter Address", text: $address)
                        CustomTextField(placeholder: "Please click to choose City", text: $city)
                            .disabled(true)
                            .onTapGesture {
                                showCities = true
                            }.sheet(isPresented: $showCities) {
                                CitiesListView(cities: addressViewModel.cities ?? []){
                                    selectedCity in
                                    city = selectedCity
                                    showCities = false
                                }
                            }.onAppear{
                                addressViewModel.getEgyptCities()
                            }
                        CustomTextField(placeholder: "Enter Country", text: $country)
                        CustomTextField(placeholder: "Enter Zip code", text: $zip)
                    }
                    
                    PrimaryButton(title: "Save") {
                        let address = AddressRequest(
                            customer_address: AddressDetails(id: nil,
                                                             customer_id: UserDefaultManager.shared.customerId, first_name: nil, last_name: nil, company: nil, address1: address, address2: nil, city: city, province: nil, country: country, zip: zip, phone: nil, name: nil, province_code: nil, country_code: "EG", country_name: country,
                                                             default: false))
                        onSaved(address)
                        
                    }.padding(.bottom, 100)
                        .padding(.top, 32)
                }.padding(.bottom)
                    .padding(.horizontal)
                    .onAppear{
                        locationViewMode.requestAccessLocation()
                    }
            }
            Spacer()
        }
    }
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            address = placemark.thoroughfare ?? "No Specific Address"
            city = placemark.locality ?? ""
            country = placemark.country ?? ""
            
            if locationViewMode.isLocationEnabled {
                locationViewMode.address = placemark.thoroughfare ?? ""
                locationViewMode.city = placemark.locality ?? ""
                locationViewMode.country = placemark.country ?? ""
            }
        }
    }
}

/*#Preview {
    AddAddress()
}*/
