//
//  AlertVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 6/2/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class AlertVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sendAlertBtn: MiddleCircleButton!
    
    @IBOutlet var typeOfAlertsButtons: [UIButton]!
    var typeOfReport:String?
    var reachability:Reachability!
    
    let tagsOfButtons:[Int] = [0,1,2,3,4,5,6]
    let typesOfReports:[String] = ["Robo","Agresión","Choque","Zona conflictiva", "Venta de drogas","Incendio"]
    
    var locationManager = CLLocationManager()
    var estadoAutorizacionUbicacion = CLLocationManager.authorizationStatus()
    let radiosRegion: Double = 2000
    var misCordenadas: CLLocationCoordinate2D?
    
    var cordenadaLongitud:Double?
    var cordenadaLatitud:Double?
    var city:String?
    var zone:String?
    var country:String?
    var zipCode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            setUbicationServices()
        }
        
        dobleTap()
    }
    
    func dobleTap() {
           let dobleTap = UILongPressGestureRecognizer(target: self, action: #selector(soltarPin(sender:)))
           dobleTap.numberOfTouchesRequired = 1
           dobleTap.delegate = self
           mapView.addGestureRecognizer(dobleTap)
       }
    
    @IBAction func alertTypeBtnWasPressed(_ sender: UIButton) {
        deleteBackgroundButtons()
        switch sender.tag {
        case 0:
            typeOfReport = typesOfReports[0]
            updateBackgroundButtons(tag: 0)
        case 1:
            typeOfReport = typesOfReports[1]
            updateBackgroundButtons(tag: 1)
        case 2:
            typeOfReport = typesOfReports[2]
            updateBackgroundButtons(tag: 2)
        case 3:
            typeOfReport = typesOfReports[3]
            updateBackgroundButtons(tag: 3)
        case 4:
            typeOfReport = typesOfReports[4]
            updateBackgroundButtons(tag: 4)
        case 5:
            typeOfReport = typesOfReports[5]
            updateBackgroundButtons(tag: 5)
        case 6:
            updateBackgroundButtons(tag: 6)
        default:
            print("tag no encontrado")
        }
    }
    
    func updateBackgroundButtons(tag:Int){
        for tagOfButton in tagsOfButtons {
            if(tag != typeOfAlertsButtons[tagOfButton].tag){
                typeOfAlertsButtons[tagOfButton].backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
    
    func deleteBackgroundButtons(){
        for tagOfButton in tagsOfButtons {
            typeOfAlertsButtons[tagOfButton].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
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
                                self.zone = pm.subLocality!
                                  adressString = adressString + pm.subLocality! + ", "
                              }
                              if pm.thoroughfare != nil {
                                  adressString = adressString + pm.thoroughfare! + ", "
                              }
                              if pm.locality != nil {
                                self.city = pm.locality!
                                  adressString = adressString + pm.locality! + ", "
                              }
                              if pm.country != nil {
                                self.country = pm.country!
                                  adressString = adressString + pm.country! + ", "
                              }
                              if pm.postalCode != nil {
                                self.zipCode = pm.postalCode!
                                  adressString = adressString + pm.postalCode! + " "
                              }
                              print(adressString)
                          }
                  })
           }
       }
    
    @IBAction func sendAlertBtnWasPressed(_ sender: Any) {
        if cordenadaLongitud != nil,
            cordenadaLatitud != nil,
            city != nil,
            zone != nil,
            typeOfReport != nil {
            let alert = self.mostrarAlertCargando(toTittle: "Espere...", toMessage: "Estamos enviando tu reporte")
                let id = DB_BASE.childByAutoId().key
                guard let userID = Auth.auth().currentUser?.uid else { return }
                
                let incidentData = ["city" : city ?? "",
                                    "date" : "",
                                    "description" : " Ocurrio un robo",
                                    "latitude" : cordenadaLatitud ?? "",
                                    "longitude": cordenadaLongitud ?? "",
                                    "title" : typeOfReport ?? "",
                                    "type" : typeOfReport ?? "",
                                    "zone" : zone ?? "",
                                    "userId" : userID
                    ] as [String : Any]
                
            DataServices.instance.createIncidentsDB(uid: id!, dataIncidents: incidentData) { (success, error) in
                DispatchQueue.main.async {
                    if success {
                       alert.dismiss(animated: true, completion: {
                        self.showAlertSuccess(title: "Listo!", body: "Tu reporte ha sido agregado")
                        self.cleanData()
                        self.deleteBackgroundButtons()
                       })
                    }else {
                        alert.dismiss(animated: true, completion: {
                            self.showAlertError(title: "Ups", body: "Algo salió mal intentalo más tarde")
                        })
                    }
                }
            }
        }else {
            self.showAlertError(title: "Ups", body: "Asegurate de seleccionar un incidencia y la ubicación!")
        }
    }
    
    func cleanData(){
        cordenadaLongitud = nil
        cordenadaLatitud = nil
        city = nil
        zone = nil
        typeOfReport = nil
    }
    
    
}

extension AlertVC : MKMapViewDelegate {
    
    func setUserLocationOnMapInTheCenter() {
       guard let coordinate = locationManager.location?.coordinate else { return }
       
       let coordianteRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: radiosRegion * 2.0, longitudinalMeters: radiosRegion * 2.0)
       mapView.setRegion(coordianteRegion, animated: true)
       removePin()
       let annotation = SoltarPin(coordinate: coordinate, identifier: "drppablePin")
        
        cordenadaLatitud = coordinate.latitude
        cordenadaLongitud = coordinate.longitude
       mapView.addAnnotation(annotation)
       self.getAddressWithCoordenates(forLatitud: coordinate.latitude, forLongitud: coordinate.longitude)
    }
    
    @objc func soltarPin(sender: UITapGestureRecognizer) {
        removePin()
        if sender.state == .ended {
       
        }
        
        let puntoTouch = sender.location(in: mapView)
        let cordenadasToque = mapView.convert(puntoTouch, toCoordinateFrom: mapView)
        let annotation = SoltarPin(coordinate: cordenadasToque, identifier: "drppablePin")
        mapView.addAnnotation(annotation)
        
        getAddressWithCoordenates(forLatitud: cordenadasToque.latitude, forLongitud: cordenadasToque.longitude)
        
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

extension AlertVC : CLLocationManagerDelegate {
    
    func setUbicationServices() {
        if estadoAutorizacionUbicacion == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            } else if estadoAutorizacionUbicacion == .authorizedAlways || estadoAutorizacionUbicacion == .authorizedWhenInUse {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                self.misCordenadas = self.locationManager.location?.coordinate
        }
        else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        setUserLocationOnMapInTheCenter()
    }
}
