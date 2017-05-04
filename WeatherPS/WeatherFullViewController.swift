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

    // weather fields shown on initial brief view
   @IBOutlet weak var tempLabel: UILabel!
   @IBOutlet weak var conditionIcon: UIImageView!
   @IBOutlet weak var timeLabel: UILabel!
   @IBOutlet weak var conditionsLabel: UILabel!
    
    
    @IBOutlet weak var map : MKMapView!
    
    // Array collection of MyWeather class ( which holds the weather data members of interest )
    var weatherCollection = Array<MyWeather>()
    
    // location manager to get the location from
    var locationManager = CLLocationManager()

    // the query string to be built for calling the API
    var queryString : String?
    
    //let urlString = "https://api.wunderground.com/api/affbb21f7da824a5/hourly/q/37.857657,-122.295500.json"
    
//    var latitude : Double?
//    var longitude : Double?
//    var ZIP : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the deletegate and preferences of the location manager, requesting location from the user
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()


        // Do any additional setup after loading the view.
    }

    private func parseJSON (queryString : String)  {
        // Parsing function to parse the data by calling API from the url created from passed query string built in func locationManager
        if let url = URL(string : queryString){
            if let data = try? Data(contentsOf: url){
                let parsedJSON = JSON.init(data: data)
                let WPData = parsedJSON["hourly_forecast"]
                var counter = 0 // counter to track number of MyWeather objects
                
                // looping through the JSON to extract data of interest into temp variables and initializing a MyWeather object and appending it to array collection
                for (_, jsonValue): (String,JSON) in WPData {
                    let condition = jsonValue["condition"]
                    let icon_url = jsonValue["icon_url"]
                    let humidity = jsonValue["humidity"]
                    let time = jsonValue["FCTTIME"]["civil"]
                    let time_worded = jsonValue["FCTTIME"]["weekday_name_abbrev"]
                    let temp_e = jsonValue["temp"]["english"]
                    let temp_m = jsonValue["temp"]["metric"]
                    let iconURL = URL(string: icon_url.string!)
                    
                    // checking for null values
                    if ( JSON.null ==  condition || JSON.null ==  icon_url ||  JSON.null ==  humidity ||
                        JSON.null ==  time ||  JSON.null ==  time_worded ||  JSON.null ==  temp_e ||  JSON.null ==  temp_m || iconURL == nil ) {
                        continue
                    }
                    
                    // creating the current obj from extracted data in temp variables
                    let currentWeatherObj = MyWeather(time: time.stringValue,
                                                      time_worded: time_worded.stringValue,
                                                      condition : condition.stringValue,
                                                      temp_e: temp_e.stringValue,
                                                      temp_m: temp_m.stringValue,
                                                      icon_url: iconURL!)
                    // appending the current obj to array collection
                    weatherCollection.append(currentWeatherObj)
                    counter+=1
                }
    
                print("counter is \(counter)")

            }
            // setting the initial brief view temperature fields to show the first (most recent) hour weather info from API as current info
            tempLabel.text = " \(weatherCollection[0].temp_e) °F / \(weatherCollection[0].temp_m) °C "
            timeLabel.text = "\(weatherCollection[0].time)"
            conditionsLabel.text = "\(weatherCollection[0].condition)"

            // setting the weather condition icon's image async'ly
            let url = weatherCollection[0].icon_url
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    self.conditionIcon.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // getting user location and saving lat and long
        let location = locations[0]
        let latitude =  location.coordinate.latitude.rounded()
        let longitude = location.coordinate.longitude.rounded()
        
        let myLocation = UserLocation(lat: latitude, long: longitude)
        
        // creating and joining fields required by API call for hourly weather for an area by co-ordinates
        let baseURL = "http://api.wunderground.com/api/"
        let api_key = WeatherInfo.WeatherAPIKey.API_Key
        let type = "/hourly/q/"
        let lat =  String (describing: myLocation.lat)
        let long =  String (describing: myLocation.long)
        let format = ".json"
        queryString = baseURL.appending(api_key).appending(type).appending(lat).appending(",").appending(long).appending(format)
        
         print(queryString!)
         print ("Location longitude is : \(latitude)" )
         print ("Location latitude is : \(longitude)" )
        
        
        // creating span and region for the mapview , setting mapview
        let center = CLLocationCoordinate2DMake(latitude,longitude)
        let span = MKCoordinateSpanMake(0.99, 0.99)
        let region = MKCoordinateRegion(center: center, span: span)
        self.map.setRegion(region, animated: true)
        
        // calling the parseJSON func with created query
        parseJSON(queryString: queryString!)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Error encountered")
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        
        // passing the weather collection data to detailview to display data in table view
        if let destination = destination as? WeatherDetailTVController {
            destination.myWeather = weatherCollection
        
        }

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
