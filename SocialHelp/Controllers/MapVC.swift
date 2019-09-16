//
//  MapVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 6/2/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapVC: UIViewController {
    //Declaracion de variables
    @IBOutlet weak var alertButton: CircleDesignButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var pulseLayers = [CAShapeLayer]()
    let usersRef = Database.database().reference(withPath: "online")
    
    var locationManager = CLLocationManager()
    var ubicationAuthorizationStatus = CLLocationManager.authorizationStatus()
    let radiosRegion: Double = 2000
    var myCoordinates: CLLocationCoordinate2D?
    
    var cordenadaLongitud:Double?
    var cordenadaLatitud:Double?
    
    var user: User!
    var reachability:Reachability!
    
    var incidents:[Incidents]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            configuracionServiciosLocalizacion()
        }
        doubleTap()
        setUserOnline()
        self.reachability = Reachability.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(conexion), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch  {
            print("error en la notificacion")
        }
        
        DataServices.instance.getIncidentsByCity(toCity: "Colima") { (success, error, incidents:[Incidents]?) in
            DispatchQueue.main.async {
                if success {
                    if let incidents = incidents {
                        self.incidents = incidents
                        self.addIncidentsToMap(incidents: self.incidents!)
                    }
                }else {
                    //nothing
                }
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        locationManager.stopUpdatingLocation()
    }
    
    @objc func conexion(nota:Notification){
          let reach = nota.object as! Reachability
          switch reach.connection {
          case .wifi:
            self.showStatusBarWithTitle(text: "", show: false)
          case .cellular:
          self.showStatusBarWithTitle(text: "Estas utilizando tus datos móviles", show: true)
          case .none:
          self.showStatusBarWithTitle(text: "no hay conexión a internet", show: true)
          }
      }
    @IBAction func alertBtnWasPressed(_ sender: Any) {
//        if(alertButton.isSelected){
//            createPulse()
//        }else{
//            alertButton.layer.removeAllAnimations()
//        }
        //alertButton.layer.removeAllAnimations()
        removeAllAnimations()
    }
    
    func setUserOnline(){
        Auth.auth().addStateDidChangeListener { auth, user in
                 guard let user = user else { return }
                 self.user = User(authData: user)
                 
                 let currentUserRef = self.usersRef.child(self.user.uid)
                 currentUserRef.setValue(self.user.email)
                 currentUserRef.onDisconnectRemoveValue()
               }
               
               usersRef.observe(.value, with: { snapshot in
                    if snapshot.exists() {
                       print(snapshot.childrenCount.description)
                    } else {
                        print("0")
                    }
                  })
    }
    
    func createPulse() {
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.size.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 2.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = CGPoint(x: alertButton.frame.size.width/2.0, y: alertButton.frame.size.width/2.0)
            alertButton.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animatePulse(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.animatePulse(index: 2)
                }
            }
        }
    }
    
    func animatePulse(index: Int) {
        pulseLayers[index].strokeColor = UIColor.black.cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
        
    }
    
    func removeAllAnimations(){
        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
    }
    
    func getAddressWithCoordenates(forLatitud latitud: Double, forLongitud longitud : Double) {
        if latitud != 0.0 && longitud != 0.0 {
            var centro : CLLocationCoordinate2D = CLLocationCoordinate2D()
               
               var adressString : String = ""
               
               let lat: Double = latitud
               let lon: Double = longitud
               
               let ceo: CLGeocoder = CLGeocoder()
               centro.latitude = lat
               centro.longitude = lon
               
               let loc: CLLocation = CLLocation(latitude:centro.latitude, longitude: centro.longitude)
               
               ceo.reverseGeocodeLocation(loc, completionHandler:
                   {(placemarks, error) in
                       if (error != nil)
                       {
                           print("error: \(error!.localizedDescription)")
                       }
                    guard let pm = placemarks else { return }
                       
                       if pm.count > 0 {
                           let pm = placemarks![0]
                          
                           if pm.subLocality != nil {
                               adressString = adressString + pm.subLocality! + ", "
                           }
                           if pm.thoroughfare != nil {
                               adressString = adressString + pm.thoroughfare! + ", "
                           }
                           if pm.locality != nil {
                               adressString = adressString + pm.locality! + ", "
                           }
                           if pm.country != nil {
                               adressString = adressString + pm.country! + ", "
                           }
                           if pm.postalCode != nil {
                               adressString = adressString + pm.postalCode! + " "
                           }
                           print(adressString)
                       }
               })
        }
    }
    
    func addIncidentsToMap(incidents: [Incidents]) {
        for incident in incidents {
            mapView.addAnnotations([setIncidentsOnMap(incident: incident)])
        }
    }
    
    func setIncidentsOnMap(incident:Incidents) -> MKAnnotation {
        
        let pointAnnotation = CustomPointAnnotation()
       // pointAnnotation.pinCustomImageName = "icon-map-point"
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(incident.latitude, incident.longitude)
        pointAnnotation.title = incident.type
        pointAnnotation.subtitle = incident.description
        
        let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        return pinAnnotationView.annotation!
    }
}


//start extension to gesture Recognizer
extension MapVC : UIGestureRecognizerDelegate {
    
    func doubleTap() {
        let dobleTap = UILongPressGestureRecognizer(target: self, action: #selector(soltarPin(sender:)))
        dobleTap.numberOfTouchesRequired = 1
        dobleTap.delegate = self
        mapView.addGestureRecognizer(dobleTap)
    }
}


//start extension to location Manager
extension MapVC : CLLocationManagerDelegate {
    
    func configuracionServiciosLocalizacion() {
             if ubicationAuthorizationStatus == .notDetermined {
                 locationManager.requestAlwaysAuthorization()
                 locationManager.requestWhenInUseAuthorization()
                 } else if ubicationAuthorizationStatus == .authorizedAlways || ubicationAuthorizationStatus == .authorizedWhenInUse {
                     locationManager.delegate = self
                     locationManager.desiredAccuracy = kCLLocationAccuracyBest
                     locationManager.startUpdatingLocation()
                     self.myCoordinates = self.locationManager.location?.coordinate
             }
             else {
                 return
             }
         }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        setUserLocationOnMapInTheCenter()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        setUserLocationOnMapInTheCenter()
    }
    
}


//start extension to mapkit
extension MapVC : MKMapViewDelegate {
    
    func setLocationServices() {
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
    }
    
    func setUserLocationOnMapInTheCenter() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        let coordianteRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: radiosRegion * 2.0, longitudinalMeters: radiosRegion * 2.0)
        mapView.setRegion(coordianteRegion, animated: true)
        removePin()
        let annotation = SoltarPin(coordinate: coordinate, identifier: "drppablePin")
        mapView.addAnnotation(annotation)
        self.getAddressWithCoordenates(forLatitud: coordinate.latitude, forLongitud: coordinate.longitude)
    }
    
    @objc func soltarPin(sender: UITapGestureRecognizer) {
        removePin()
        if sender.state == .ended {
       
        }
        
        let puntoTouch = sender.location(in: mapView)
        print("touch point\(puntoTouch)")
        let cordenadasToque = mapView.convert(puntoTouch, toCoordinateFrom: mapView)
        print("touch touchCoordinate\(cordenadasToque)")
        let annotation = SoltarPin(coordinate: cordenadasToque, identifier: "drppablePin")
    
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegion(center: cordenadasToque, latitudinalMeters: radiosRegion * 2.0, longitudinalMeters: radiosRegion * 2.0)
        
        cordenadaLatitud = coordinateRegion.center.latitude
        cordenadaLongitud = coordinateRegion.center.longitude
        self.getAddressWithCoordenates(forLatitud: cordenadaLatitud!, forLongitud: cordenadaLongitud!)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var pinCustomImageName:String!
}
