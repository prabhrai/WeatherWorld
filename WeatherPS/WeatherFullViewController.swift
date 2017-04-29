//
//  WeatherFullViewController.swift
//  WeatherPS
//
//  Created by PS on 4/25/17.
//  Copyright © 2017 PS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class WeatherFullViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var map : MKMapView!
    
    var locationManager = CLLocationManager()
    
    var myLocation : UserLocation?
    var myQueryURL : URL?
    
    let urlString = "https://api.wunderground.com/api/affbb21f7da824a5/hourly/q/37.857657,-122.295500.json"
    
    var latitude : Double?
    var longitude : Double?
    var ZIP : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

         print("I'm here in VDL")


        if let url = URL(string : urlString){
            if let data = try? Data(contentsOf: url){
                let parsedJSON = JSON.init(data: data)
        
                let WPData = parsedJSON["hourly_forecast"]
                
  
                for (key, jsonValue): (String,JSON) in WPData {
                     print("\n\n\n\n  ")
                    
//                    let WPTime = WPData["FCTTIME"]
//                    for (key1, jsonValue1): (String,JSON) in WPTime {
//                        print (" Key : \(key1) ++++++++ jsonValue : \(jsonValue1)" )
//                    }
                    
                     print("\n\n\n\n ")
                    let condition = jsonValue["condition"]
                    let icon_url = jsonValue["icon_url"]
                    let humidity = jsonValue["humidity"]
                    let time = jsonValue["FCTTIME"]["civil"]
                    let time_worded = jsonValue["FCTTIME"]["weekday_name_night"]
                    let temp_e = jsonValue["temp"]["english"]
                    let temp_f = jsonValue["temp"]["metric"]
                    let iconURL = URL(string: icon_url.string!)
                    
                    
                    if ( JSON.null ==  condition || JSON.null ==  icon_url ||  JSON.null ==  humidity ||
                        JSON.null ==  time ||  JSON.null ==  time_worded ||  JSON.null ==  temp_e ||  JSON.null ==  temp_f || iconURL == nil ) {
                        continue
                    }
                    
                    
                    
                    print (" Key : \(key) ---- jsonValue : \(jsonValue)" )
                    
                    
                    
                    
                    
                    
                    
                    
//                    print("\n\n\n\n ")
//
//                    print (" condition :   \t     \(condition)       ")
//                    print (" icon_url :    \t     \(icon_url)       ")
//                    print (" humidity :   \t      \(humidity)       ")
//                    print (" time_worded :  \t    \(time_worded)       ")
//                    print (" time :     \t        \(time)       ")
//                    print (" temp_e :   \t        \(temp_e)       ")
//                    print (" temp_f :   \t        \(temp_f)       ")
//                    print("\n\n\n\n ")

                }
                
                
                
                
           // print("\n\n\n\n\n\n\n\n\n\n\n\n ")
                
           // print(parsedJSON)
                
            print("\n---------------------\n ")
            }
 
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let latt =  location.coordinate.latitude.rounded()
        let longg = location.coordinate.longitude.rounded()
        
        myLocation = UserLocation(lat: latt, long: longg)
        print("I'm here in LM")
        print ("Location longitude is : \(location.coordinate.latitude.rounded())" )
        print ("Location latitude is : \(location.coordinate.longitude.rounded())" )
        
        myQueryURL = createURL()
        
        let center = CLLocationCoordinate2DMake((myLocation?.lat)! , (myLocation?.long)!)
        let span = MKCoordinateSpanMake(0.99, 0.99)
        let region = MKCoordinateRegion(center: center, span: span)
        self.map.setRegion(region, animated: true)
       // myLocation = UserLocation(lat :  lat, long : long)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Error encountered")
    }
    
    func createURL()->URL? {
        
        var parameters = Dictionary<String,String>()
        let baseURL = "http://api.wunderground.com/api/"
        parameters["api_key"] = WeatherInfo.WeatherAPIKey.API_Key
        parameters["type"] = "hourly/q/"
        parameters["latitude"] =  String (describing: myLocation?.lat)
        parameters["longitude"] =  String (describing: myLocation?.long)
        parameters["format"] = ".json"
        
        var queryItems = Array<URLQueryItem>()
        for (key,value) in parameters {
            queryItems.append(URLQueryItem(name : key , value : value) )
        }
        
        let urlComponents = NSURLComponents(string: baseURL)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
