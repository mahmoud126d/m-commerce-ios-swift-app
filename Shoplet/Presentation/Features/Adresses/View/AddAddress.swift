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
    @State private var phoneNumber = ""
    @StateObject var locationViewMode: LocationViewModel = LocationViewModel()
    @StateObject var addressViewModel: AddressViewModel = AddressViewModel()
    @State var selectedLocation: CLLocationCoordinate2D?
    @State var showCities = false
    @State var isError = false
    @State private var addressLabel: String? = nil
    let addressLabels = ["Home", "Office"]
    var onSaved: ()->Void
    
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
                    }
                    CustomTextField(placeholder: "Enter Zip code", text: $zip)
                    CustomTextField(placeholder: "Enter Phone Number", text: $phoneNumber)
                    Text("Address Label (Optional)")
                        .font(.subheadline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)

                    Picker("Address Label", selection: Binding(
                        get: { addressLabel ?? "None" },
                        set: { newValue in
                            addressLabel = newValue == "None" ? nil : newValue
                        }
                    )) {
                        ForEach(addressLabels, id: \.self) { label in
                            Text(label).tag(label)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical)

                    PrimaryButton(title: "Save") {
                        if validateFields(){
                        
                            let address = AddressRequest(
                                customer_address: AddressDetails(id: nil,
                                                                 customer_id: UserDefaultManager.shared.customerId, first_name: nil, last_name: nil, company: addressLabel, address1: address == "" ? locationViewMode.address : address, address2: nil, city: city == "" ? locationViewMode.city : city, province: nil, country: country == "" ? locationViewMode.country : country, zip: zip, phone: phoneNumber, name: nil, province_code: nil, country_code: "EG", country_name: country,
                                                                 default: false))
                             onSaved()
                            addressViewModel.createAddress(address: address)
                        }else{
                            isError = true
                        }
                    }
                    .padding(.top, 32)
                    if isError{
                        Text("All fields are required")
                               .foregroundColor(.red)
                               .font(.headline)
                               .padding(.bottom, 50)
                    }
                    Spacer().frame(height: 100)
                }.padding(.bottom)
                    .padding(.horizontal)
                    .onAppear{
                        //locationViewMode.requestAccessLocation()
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
                address = placemark.thoroughfare ?? "No Specific Address"
                city = placemark.locality ?? ""
                country = placemark.country ?? ""
            }
        }
    }
    func validateFields() -> Bool {
        if locationViewMode.isLocationEnabled {
            return !locationViewMode.address.isEmpty && !locationViewMode.city.isEmpty && !locationViewMode.country.isEmpty && !zip.isEmpty && !phoneNumber.isEmpty
        } else {
            return !address.isEmpty && !city.isEmpty && !country.isEmpty && !zip.isEmpty && !phoneNumber.isEmpty
        }
    }

}

/*#Preview {
    AddAddress()
}*/
