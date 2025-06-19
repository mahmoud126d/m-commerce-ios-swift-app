//
//  Map.swift
//  Shoplet
//
//  Created by Macos on 18/06/2025.
//

import SwiftUI
import MapKit

struct MapRegion : UIViewRepresentable{
    @Binding var region: MKCoordinateRegion
    var isEnable: Bool
    var pinCoordinate: CLLocationCoordinate2D?
    var onTap: ((CLLocationCoordinate2D) -> Void)? = nil
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

                let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapTapped(_:)))
                mapView.addGestureRecognizer(tapGesture)

                return mapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
       
        uiView.setRegion(region , animated: true)
        uiView.showsUserLocation = isEnable
        uiView.isUserInteractionEnabled = isEnable
        uiView.removeAnnotations(uiView.annotations)
                if let pin = pinCoordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = pin
                    uiView.addAnnotation(annotation)
                }
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    class Coordinator: NSObject, MKMapViewDelegate {
            let parent: MapRegion

            init(_ parent: MapRegion) {
                self.parent = parent
            }

            @objc func mapTapped(_ gesture: UITapGestureRecognizer) {
                guard let mapView = gesture.view as? MKMapView else { return }
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                parent.onTap?(coordinate)
            }
        }
    }
    



#Preview {
    Map()
}
