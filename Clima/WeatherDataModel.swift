import UIKit

class WeatherDataModel {
    //Declare your model variables here
    var temperature : Int = 0
    var condition : Int = 0
    var city : String = ""
    var weatherIconName : String?

    func getIcon() -> String {
        if let icon = weatherIconName {
            return icon
        }
        else {
            return "dunno"
        }
    }
    //This method turns a condition code into the name of the weather condition image
    func updateWeatherIcon() {
        switch (condition) {
        case 0...300 :
            weatherIconName = "tstorm1"
        case 301...500 :
            weatherIconName = "light_rain"
        case 501...600 :
            weatherIconName = "shower3"
        case 601...700 :
            weatherIconName = "snow4"
        case 701...771 :
            weatherIconName = "fog"
        case 772...799 :
            weatherIconName = "tstorm3"
        case 800 :
            weatherIconName = "sunny"
        case 801...804 :
            weatherIconName = "cloudy2"
        case 900...903, 905...1000  :
            weatherIconName = "tstorm3"
        case 903 :
            weatherIconName = "snow5"
        case 904 :
            weatherIconName = "sunny"
        default :
            weatherIconName = "dunno"
        }
    }
}
