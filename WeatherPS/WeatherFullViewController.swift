//
//  WeatherFullViewController.swift
//  WeatherPS
//
//  Created by PS on 4/25/17.
//  Copyright © 2017 PS. All rights reserved.
//

import UIKit
import MapKit

class WeatherFullViewController: UIViewController {

    @IBOutlet weak var map : MKMapView!
    
    var latitude : Double?
    var longitude : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let center = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpanMake(0.3, 0.3)
        let region = MKCoordinateRegion(center: center, span: span)
        
        self.map.setRegion(region, animated: true)
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
