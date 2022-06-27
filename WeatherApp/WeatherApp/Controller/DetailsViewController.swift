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

class DetailsViewController: UIViewController, CLLocationManagerDelegate, MKLocalSearchCompleterDelegate, UISearchBarDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityTimeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempertureLabel: UILabel!
    @IBOutlet weak var minimalTempertureLabel: UILabel!
    @IBOutlet weak var maximunTempertureLabel: UILabel!
    @IBOutlet weak var currentPressureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var models = [Result] ()
    
    var timeZone = ""
    
    let locationManager = CLLocationManager()
    
    var selectedCity: String?
    
    var currentLocation: CLLocation?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation(forPlaceCalled: selectedCity!) { location in
            guard let location = location else { return }
            
            self.currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.mapView.centerToLocation(self.currentLocation!)
            self.locationManager.stopUpdatingLocation()
            self.requestWeatherForLocation()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setupLocation()
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
            
            DispatchQueue.main.async{
                self.timeZone = self.timeZoneToRealTime(timeZone: result.timezone)
                
                let dateTest = self.localDate(timeZone: result.timezone)
                
                self.cityTimeLabel.text = "\(dateTest)"
                
                self.cityNameLabel.text = "\(result.name)"
                
                self.currentWeatherDescriptionLabel.text = "\(result.weather[0].description)"
                
                let currentTemperature = self.convertToCelsius(kelvin: result.main.temp)
                
                let currentMinTemperature = self.convertToCelsius(kelvin: result.main.temp_min)
                
                let currentMaxTemperature = self.convertToCelsius(kelvin: result.main.temp_max)
                
                self.currentTempertureLabel.text = "\(currentTemperature)º"
                
                self.minimalTempertureLabel.text = "\(currentMinTemperature)º"
                
                self.maximunTempertureLabel.text = "\(currentMaxTemperature)º"
                
                self.currentHumidityLabel.text = "\(result.main.humidity)%"
                
                self.currentPressureLabel.text = "\(result.main.pressure)"
                
            }
            
            // MARK: Upadate user interface
            
        }).resume()
        
    }
    
    func localDate(timeZone: Int) -> String {
        let nowUTC = Date()
        let timeZoneOffset = timeZone
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return String()}
        
        let dateFormatter  = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate = dateFormatter.string(from: localDate)
        
        print("Local Date: \(localDate)")
        print("Converted Date: \(convertedDate)")
        
        return convertedDate
    }
    
    func convertToCelsius(kelvin: Float) -> Int {
        let converted = kelvin - 273.15
        return Int(converted)
    }
 
    //MARK: Local Converter
    func getLocation(forPlaceCalled name: String,
                     completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }

            completion(location)
        }
    }
}
