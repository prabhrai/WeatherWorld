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
    
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var scale: UISegmentedControl!
    
    @IBAction func getUserLocation(_ sender: Any) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
         print ("Location is : ")
    }
    
    @IBAction func getWeather(_ sender: Any) {
        locationManager.stopUpdatingLocation()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        print ("Location is : \(location.altitude)" )
        print ("Location is : \(location.coordinate)" )
      
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
