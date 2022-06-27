//
//  ViewController.swift
//  WeatherApp
//
//  Created by Cassiano Carradore Salgado on 24/06/22.
//

import UIKit
import CoreLocation
import MapKit

// custom cell: collection view

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var models = [Result] ()
    
    var timeZone = ""
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocation()
    }
    
    func timeZoneToRealTime(timeZone: Int) -> String {
        let hours = timeZone/3600
        let minutes = abs(timeZone/60) % 60
        let tz = String(format: "%+.2d:%.2d", hours, minutes)
        print(tz)
        return tz
    }
    
    // MARK: Location
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            mapView.centerToLocation(currentLocation!)
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=558b97a543fdd94ab6620fc2a0989e90"

        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { [self]data, response, error in
            guard let data = data, error == nil else {
                print("Somenthing went wrong!")
                return
            }
            
            // MARK: Convert data to models
            var json: Result?
            do {
                json = try JSONDecoder().decode(Result.self, from: data)
            }
            catch {
                print("Error: \(error)")
            }
            
            guard let result = json else  {
                return
            }
            
            print(result)
            
            self.models.append(result)
            
            let weatherData: [Weather] = result.weather
            
            UIImage.loadFrom(url: weatherData[0].iconUrl) { image in
                self.imageView.image = image
            }
            
            timeZone = timeZoneToRealTime(timeZone: result.timezone)
            
            let dateTest = localDate(timeZone: result.timezone)
            
            // MARK: Upadate user interface
            
        }).resume()
        
    }
    
    func localDate(timeZone: Int) -> Date {
        let nowUTC = Date()
        let timeZoneOffset = timeZone
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        let dateFormatter  = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate = dateFormatter.string(from: localDate)
        
        print("Local Date: \(localDate)")
        print("Converted Date: \(convertedDate)")
        
        return localDate
    }
    
    // MARK: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
