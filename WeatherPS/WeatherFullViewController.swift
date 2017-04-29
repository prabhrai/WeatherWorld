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

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    
    
    @IBOutlet weak var map : MKMapView!
    var weatherCollection = Array<MyWeather>()
    
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
                 var counter = 0
  
                for (_, jsonValue): (String,JSON) in WPData {
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
                
                    let currentWeatherObj = MyWeather(time: time.stringValue,
                                                      time_worded: time_worded.stringValue,
                                                      condition : condition.stringValue,
                                                      temp_e: temp_e.stringValue,
                                                      temp_f: temp_f.stringValue,
                                                      icon_url: iconURL!)
                    weatherCollection.append(currentWeatherObj)
                    counter+=1
                }
                print("counter is \(counter)")
                
            }
 
            
        }
        
      //  conditionIcon.image(data : NSData(contentsOf: weatherCollection[0].icon_url))
        
        //conditionIcon=UIImage(data: NSData(contentsOfURL: NSURL(string: weatherCollection[0].icon_url.absoluteString)!)!
        let url = weatherCollection[0].icon_url
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                self.conditionIcon.image = UIImage(data: data)
            }
        }
        
        task.resume()
        tempLabel.text = "It is \(weatherCollection[0].temp_e)  °F"
        timeLabel.text = "It is \(weatherCollection[0].time)"
        conditionsLabel.text = "It is \(weatherCollection[0].condition) "

        
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
