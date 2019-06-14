//
//  CoreData.swift
//  activeApp
//
//  Created by marek holik on 14/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import CoreML

class CoreData {
    
    class func createActivity(name: String, lenght: Int, locationName: String, geoPoint: CLLocationCoordinate2D, timestamp: Date, completion: (_ finished: Bool) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "CActivity", in: managedContext) else { print("returned");completion(false);return }
    
        let activity = NSManagedObject(entity: userEntity, insertInto: managedContext) as! CActivity
        
        activity.name = name
        activity.lenght = Int32(lenght)
        activity.locationName = locationName
        activity.latitude = geoPoint.latitude
        activity.longitude = geoPoint.longitude
        activity.timestamp = timestamp
    
//        activity.setValue(name, forKey: "name")
//        activity.setValue(Int32(lenght), forKey: "lenght")
//        activity.setValue(locationName, forKey: "locationName")
//        activity.setValue(geoPoint.latitude, forKey: "latitude")
//        activity.setValue(geoPoint.longitude, forKey: "longitude")
//        activity.setValue(timestamp, forKey: "timestamp")
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint(error)
            completion(false)
        }
    }
    
    class func fetch(completion: (_ finished: Bool) -> ()) -> [Activity] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [Activity]() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CActivity")

        var fetchedActivities: [CActivity] = []
        var activities: [Activity] = []
        
        do {
            fetchedActivities = try managedContext.fetch(fetchRequest) as! [CActivity]
        } catch {
            debugPrint(error)
        }
        
        for activity in fetchedActivities {
            let activity = Activity(name: activity.name!, lenght: Int(activity.lenght), locationName: activity.locationName!, locationCoordinate: CLLocationCoordinate2DMake(activity.latitude, activity.longitude), timestamp: activity.timestamp!, storage: Storage.local)
            activities.append(activity)
        }
        
        return activities
    }
}
