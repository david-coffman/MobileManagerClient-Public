//
//  MapViewController.swift
//  MobileManagerClient-UIKit
//
//  Created by David Coffman on 7/25/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    class CodableVoterAnnotation: NSObject, MKAnnotation {
        let coordinate: CLLocationCoordinate2D
        let title: String?
        let codableVoter: CodableVoter
        
        init?(from codableVoter: CodableVoter) {
            if let latitude = codableVoter.latitude, let longitude = codableVoter.longitude {
                self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.title = "\(codableVoter.firstName!) \(codableVoter.lastName!)"
                self.codableVoter = codableVoter
            }
            else {
                return nil
            }
        }
    }
    
    var selectedVoters: [CodableVoter]!
    var voterToPass: CodableVoter!
    var isFiltering: Bool!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if let latitude = selectedVoters.first?.latitude, let longitude = selectedVoters.first?.longitude {
            let frame = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.region = frame
        }
        else {
            for k in selectedVoters {
                if let latitude = k.latitude, let longitude = k.longitude {
                    let frame = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
                    mapView.region = frame
                    break
                }
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        if isFiltering {
            for selectedVoter in selectedVoters {
                if !selectedVoter.hasEngaged, let annotation = CodableVoterAnnotation(from: selectedVoter) {
                    mapView.addAnnotation(annotation)
                }
            }
        }
        else {
            for selectedVoter in selectedVoters {
                if let annotation = CodableVoterAnnotation(from: selectedVoter) {
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CVAnnotation") as? MKMarkerAnnotationView {
            annotationView.annotation = annotation
            if (annotation as! CodableVoterAnnotation).codableVoter.hasEngaged {
                annotationView.markerTintColor = .systemGreen
            }
            else {
                annotationView.markerTintColor = .systemRed
            }
            return annotationView
        }
        else {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CVAnnotation")
            if (annotation as! CodableVoterAnnotation).codableVoter.hasEngaged {
                annotationView.markerTintColor = .systemGreen
            }
            else {
                annotationView.markerTintColor = .systemRed
            }
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        voterToPass = (view.annotation as! CodableVoterAnnotation).codableVoter
        performSegue(withIdentifier: "didSelectVoterFromMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VoterDetailTableViewController {
            destination.selectedVoter = voterToPass
        }
    }
}
