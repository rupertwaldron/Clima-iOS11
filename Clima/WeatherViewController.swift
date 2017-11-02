import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController,
    CLLocationManagerDelegate, ChangeCityDelegate {
/** class conforms to CLL...ManagerDelegate so can be
 set up as delegate which gives the WeatherVC access to
 data from LocationManager Constants **/
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
// weatherViewController will now deal with location stuff
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    //MARK: - Networking
    /***************************************************************/
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in // returned data contained in response
            // this is a closure
            if response.result.isSuccess {
                print("Success we have weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                // need self as within a closure
            }
            else {
                print("Error \(response.result.error!)")
                self.cityLabel.text = "Connection issues"
            }
        }
    }
    //MARK: - JSON Parsing
    /***************************************************************/
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.updateWeatherIcon()
            updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    //MARK: - UI Updates
    /***************************************************************/
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)º"
        weatherIcon.image = UIImage(named: weatherDataModel.getIcon())
    }
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
 //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        // stop checking when result is valid
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil //stops into coming while stopping
            print("latitude = \(location.coordinate.latitude), Longitude = \(location.coordinate.longitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : latitude,
                                              "lon" : longitude,
                                              "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    //MARK: - Change City Delegate methods
    /***************************************************************/
    //Write the userEnteredANewCityName Delegate method here:
    // needs this to conform to protocol
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            // set this VC as the delegate
            destinationVC.delegate = self
        }
    }
}


