//
//  WeatherInfo.swift
//  WeatherPS
//
//  Created by PS on 4/26/17.
//  Copyright © 2017 PS. All rights reserved.
//

import Foundation

class WeatherInfo {
    
    struct WeatherAPIKey {
        static let API_Key = "affbb21f7da824a5"
    }
    

    
}

struct UserLocation {
    var lat : Double
    var long : Double
    
    init (
        lat : Double ,
        long : Double
        ){
        self.lat = lat
        self.long = long
    }

}


class MyWeather {
    let time : String
    let time_worded : String
    let condition : String
    let temp_e : String
    let temp_f : String
    let icon_url : URL

    init(   time : String,
            time_worded : String,
            condition : String,
            temp_e : String,
            temp_f : String,
            icon_url : URL ){
         self.time = time
         self.time_worded = time_worded
         self.condition = condition
         self.temp_e = temp_e
         self.temp_f = temp_f
         self.icon_url = icon_url

    }
    
    
    
    
    
}
					
