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
    
    //var myLocation = UserLocation(lat: 0,long: 0)
    var queryString : String?
    
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

        
        print("I'm here in VDL 1")

       // print(queryString!)
        
        print("Query url created ")
        
        
      //  conditionIcon.image(data : NSData(contentsOf: weatherCollection[0].icon_url))
        
        //conditionIcon=UIImage(data: NSData(contentsOfURL: NSURL(string: weatherCollection[0].icon_url.absoluteString)!)!
       
  
        
        // Do any additional setup after loading the view.
    }

    private func parseJSON (queryString : String)  {
    
        if let url = URL(string : queryString){
            if let data = try? Data(contentsOf: url){
                let parsedJSON = JSON.init(data: data)
                let WPData = parsedJSON["hourly_forecast"]
                var counter = 0
                
                for (_, jsonValue): (String,JSON) in WPData {
                    let condition = jsonValue["condition"]
                    let icon_url = jsonValue["icon_url"]
                    let humidity = jsonValue["humidity"]
                    let time = jsonValue["FCTTIME"]["civil"]
                    let time_worded = jsonValue["FCTTIME"]["weekday_name_abbrev"]
                    let temp_e = jsonValue["temp"]["english"]
                    let temp_m = jsonValue["temp"]["metric"]
                    let iconURL = URL(string: icon_url.string!)
                    
                    
                    if ( JSON.null ==  condition || JSON.null ==  icon_url ||  JSON.null ==  humidity ||
                        JSON.null ==  time ||  JSON.null ==  time_worded ||  JSON.null ==  temp_e ||  JSON.null ==  temp_m || iconURL == nil ) {
                        continue
                    }
                    
                    let currentWeatherObj = MyWeather(time: time.stringValue,
                                                      time_worded: time_worded.stringValue,
                                                      condition : condition.stringValue,
                                                      temp_e: temp_e.stringValue,
                                                      temp_m: temp_m.stringValue,
                                                      icon_url: iconURL!)
                    weatherCollection.append(currentWeatherObj)
                    counter+=1
                }
                print("counter is \(counter)")
                
            }
            
            let url = weatherCollection[0].icon_url
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    self.conditionIcon.image = UIImage(data: data)
                }
            }
            
            task.resume()
            
        }

        tempLabel.text = " \(weatherCollection[0].temp_e) °F / \(weatherCollection[0].temp_m) °C "
        timeLabel.text = "\(weatherCollection[0].time)"
        conditionsLabel.text = "\(weatherCollection[0].condition) "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let latt =  location.coordinate.latitude.rounded()
        let longg = location.coordinate.longitude.rounded()
        
        let myLocation = UserLocation(lat: latt, long: longg)
        
        let baseURL = "http://api.wunderground.com/api/"
        let api_key = WeatherInfo.WeatherAPIKey.API_Key
        let type = "/hourly/q/"
        let lat =  String (describing: myLocation.lat)
        let long =  String (describing: myLocation.long)
        let format = ".json"
        queryString = baseURL.appending(api_key).appending(type).appending(lat).appending(",").appending(long).appending(format)
        
        print(queryString!)
        print("I'm here in LM")
        print ("Location longitude is : \(location.coordinate.latitude.rounded())" )
        print ("Location latitude is : \(location.coordinate.longitude.rounded())" )
   
        let center = CLLocationCoordinate2DMake(latt,longg)
        let span = MKCoordinateSpanMake(0.99, 0.99)
        let region = MKCoordinateRegion(center: center, span: span)
        self.map.setRegion(region, animated: true)
        parseJSON(queryString: queryString!)
       // myLocation = UserLocation(lat :  lat, long : long)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Error encountered")
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        
        if let destination = destination as? WeatherDetailTVController {
            destination.myWeather = weatherCollection
        
        }

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
