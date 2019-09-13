//
//  File.swift
//  SocialHelp
//
//  Created by Misael Rivera on 6/1/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataServices {
    static let instance = DataServices()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_INCIDENTS = DB_BASE.child("incidents")
    
    var REF_BASE : DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS : DatabaseReference {
        return _REF_USERS
    }
    
    var REF_INCIDENTS : DatabaseReference {
           return _REF_INCIDENTS
       }
    
    func createUserDB(uid:String, dataUser:Dictionary<String,Any>) {
        REF_USERS.child(uid).updateChildValues(dataUser)
    }
    
    func createIncidentsDB(uid:String, dataIncidents:Dictionary<String,Any>, dataUpdate: @escaping (_ success:Bool, _ error:Error?) -> () ) {
        REF_INCIDENTS.child(uid).updateChildValues(dataIncidents)
        dataUpdate(true,nil)
    }
    
    func getIncidentsByCity(toCity city:String, completion : @escaping(_ success:Bool, _ error:String?, _ incidents:[Incidents]?) -> () ) {
        var incidents = [Incidents]()
        REF_INCIDENTS.queryOrdered(byChild: "Colima").observe(DataEventType.value) { (snapshot) in
            for incident in snapshot.children.allObjects as! [DataSnapshot] {
                if let values = incident.value as? [String:AnyObject] {
                    let city = values["city"] as? String ?? ""
                    let date = values["date"] as? String ?? ""
                    let description = values["description"] as? String ?? ""
                    let latitude = values["latitude"] as? Double ?? 0.0
                    let longitude = values["longitude"] as? Double ?? 0.0
                    let title = values["title"] as? String ?? ""
                    let type = values["type"] as? String ?? ""
                    let userId = values["userId"] as? String ?? ""
                    let zone = values["zone"] as? String ?? ""
                    
                    let incident = Incidents(city: city, date: date, description: description, latitude: latitude, longitude: longitude, title: title, type: type, userId: userId, zone: zone)
                    incidents.append(incident)
                }
            }
            if(incidents.count > 0) {
                completion(true, nil, incidents)
            }else {
                completion(false, "Error", nil)
            }
        }
        return
    }
    
}
