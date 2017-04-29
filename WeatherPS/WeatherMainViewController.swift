//
//  WeatherMainViewController.swift
//  WeatherPS
//
//  Created by PS on 4/17/17.
//  Copyright © 2017 PS. All rights reserved.
//

import UIKit



class WeatherMainViewController: UIViewController  {
	
    @IBOutlet weak var ZIP: UITextField!
  
    
    @IBAction func getWeather(_ sender: UIButton ) {
      //   locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destination = segue.destination
        
        if let destination = destination as? WeatherFullViewController {
      //      destination.myLocation = myLocation
      //       destination.latitude = lat
      //      destination.longitude = long
           destination.ZIP = ZIP.text
        }

    }
    

}
