//
//  LocationViewModel.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation
import MapKit


struct LocationCoordinate: Identifiable{
    let id = UUID()
    var location: CLLocationCoordinate2D
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    private let locationManeger =  CLLocationManager()
    @Published var loctionCoordinate: CLLocationCoordinate2D =
    CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357)
    let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var address: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    
    @Published var isLocationEnabled: Bool = false {
        didSet {
            if isLocationEnabled {
                requestAccessLocation()
            } else {
                region = MKCoordinateRegion(center: loctionCoordinate, span: span)
            }
        }
    }

    override init() {
        super.init()
        self.locationManeger.delegate = self
        region = MKCoordinateRegion(center: loctionCoordinate, span: span)
    }
    
    func requestAccessLocation(){
        locationManeger.requestWhenInUseAuthorization()
        locationManeger.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isLocationEnabled, let loc = locations.first else {
            return
        }
        loctionCoordinate = loc.coordinate
        region = MKCoordinateRegion(center: loc.coordinate, span: span)
        locationToAddress(location: loc)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    
    func locationToAddress(location: CLLocation){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let placemark = placemarks?.first {
                self.address = placemark.thoroughfare ?? ""
                self.city = placemark.locality ?? ""
                self.country = placemark.country ?? ""
            }
        }
    }
}
