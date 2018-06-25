

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(row == 0){
        getBitCoinData(coin : currencyArray[row])
        }
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        getBitCoinData(coin : currencyArray[row])
        
    }
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var finalURL="https://apiv2.bitcoinaverage.com/indices/global/ticker/short?crypto=BTC&fiat="
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        
    }

    
    func getBitCoinData(coin: String) {
        
        Alamofire.request(finalURL + coin).responseJSON{
            response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin data")
                    let coinJSON : JSON = JSON(response.result.value!)

                    self.updateCoinData(json: coinJSON, coin: coin)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    func updateCoinData(json : JSON, coin: String){
        let coinName = "BTC" + coin
        if let tempResult = json[coinName]["last"].double{
            self.bitcoinPriceLabel.text = String(Int(tempResult))
            
        }else{
            self.bitcoinPriceLabel.text = "Unavailable"
        }
        
    }


}

