//
//  ViewController.swift
//  Rain Or Shine
//
//  Created by Taha Abbasi on 5/31/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPrecepitationLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentWeatherSummary: UILabel?
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var userLocationLabel: UILabel?
    
    private let forecastAPIKey = "ae43ffe0eef2e5f0124d69b611276243"
    
    var locationManager = CLLocationManager()
    
    var userCity = ""
    var userState = ""
    
//    let coordinate: (lat: Double, long: Double) = (37.8267,-122.423)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
//        geoCodeLocationFromString()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        locationManager.stopUpdatingLocation()
        
        var userLocation : CLLocation = locations[0] as! CLLocation
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        toggleRefreshAnimation(true)
        retrieveWeatherForecast(latitude, longitude: longitude)
        
        var geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            let placeArray = placemarks as! [CLPlacemark]
            
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray[0]
            
            // Address dictionary
//            println(placeMark.addressDictionary)
            
            // City
            if let city = placeMark.addressDictionary["City"] as? NSString {
                self.userCity = "\(city), "
            }
            
            // City
            if let state = placeMark.addressDictionary["State"] as? NSString {
                self.userState = state as String
            }
            
            self.userLocationLabel?.text = "\(self.userCity)\(self.userState)"
            
        })
    }
    
    
//     Work on this!
//    func geoCodeLocationFromString() {
//        
//        var geoCoder = CLGeocoder()
//        
//        
//        var zip = "Seattle"
//        
//        geoCoder.geocodeAddressString(zip, completionHandler: { (placemarks, error) -> Void in
//            
//            if error != nil {
//                println(error)
//            } else {
//                
//                if let placeMark = placemarks?[0] as? CLPlacemark {
//                    println(placeMark)
//                    var location : CLLocation = placeMark.location as CLLocation
//                    
//                    var latitude = location.coordinate.latitude
//                    var longitude = location.coordinate.longitude
//                    
//                    var state = placeMark.addressDictionary["State"] as! String
//                    println(state)
//                    
//                    println("\n\n\n\n\n\(location)\n\n\n\n\n\(latitude) : \(longitude)")
//                }
//                
//            }
//            
//        })
//    }

    func retrieveWeatherForecast(latitude:
        CLLocationDegrees, longitude: CLLocationDegrees) {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(latitude, long: longitude) {
            (let currently) in
            if let currentWeather = currently {
                // Update UI
                dispatch_async(dispatch_get_main_queue()) {
                    // Execute closure
                    
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                    }
                    
                    
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecepitationLabel?.text = "\(precipitation)%"
                    }
                    
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    
                    if let summary = currentWeather.summary {
                        self.currentWeatherSummary?.text = summary
                    }
                    self.toggleRefreshAnimation(false)
                }
            }
        }
    }

    @IBAction func refreshWeather() {
        toggleRefreshAnimation(true)
        locationManager.startUpdatingLocation()
        
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton?.hidden = on
        if on {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }
}

