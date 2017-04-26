//
//  WeatherMainViewController.swift
//  WeatherPS
//
//  Created by PS on 4/17/17.
//  Copyright © 2017 PS. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherMainViewController: UIViewController , CLLocationManagerDelegate{
	
    var locationManager = CLLocationManager()
    
    var lat : Double?
    var long : Double?
    
    
    // @IBOutlet weak var city: UITextField!
    // @IBOutlet weak var state: UITextField!
    // @IBOutlet weak var scale: UISegmentedControl!
    
    @IBAction func getUserLocation(_ sender: Any) {
        
      print ("Location longitude is " )

    }
    
    @IBAction func getWeather(_ sender: Any) {
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
       // locationManager.delegate = self
       // locationManager.requestAlwaysAuthorization()
        
         //view.backgroundColor = UIColor.gray

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
         lat = location.coordinate.latitude.rounded()
         long = location.coordinate.longitude.rounded()

        print ("Location longitude is : \(location.coordinate.latitude.rounded())" )
        print ("Location latitude is : \(location.coordinate.longitude.rounded())" )
      
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destination = segue.destination
        
        if let destination = destination as? WeatherFullViewController {
            destination.latitude = lat
            destination.longitude = long
        }
        
        
    }
    

}
