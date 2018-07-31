//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Jesus Perez on 08/12/2018.
//  Copyright © 2016 Jesus Perez. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    
    //For the UI Button Picker pre-requisites
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //For the UI Button Picker Rows or how many options we got in numbers
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //For the UI Picker Button Names 'titles' themeselves
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //For the UI Picker action when a user stops on an option
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        //Adding the currency name to the end of the base URL
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        //Updating the money here
        getBitcoinData(url: finalURL)
        updateBitcoinLabel()
        
        //Updating the symbol
        selectedSymbol = symbolArray[row]
        
    }
    
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var selectedSymbol = ""
    var bitcoinAverage : Double = 0
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate   = self
        currencyPicker.dataSource = self
        
    }
    
    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    
    
    
        //MARK: - Networking
        /***************************************************************/
    
        func getBitcoinData(url: String) {
    
            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.result.isSuccess {
    
                        print("Sucess! Got the Bitcoin data")
                        let bitcoinJSON : JSON = JSON(response.result.value!)
                        self.updateBitcoinJSON(json: bitcoinJSON)
    
                    } else {
                        
                        print("Error: \(String(describing: response.result.error))")
                        self.bitcoinPriceLabel.text = "Connection Issues"
                    }
                    
                }
        }
    
    

    //MARK: - JSON Parsing
    /***************************************************************/

    func updateBitcoinJSON(json : JSON) {
        
        //This line of code is only to acces the bitcoinAverage value
        if json["ask"].int != nil {
 
            bitcoinAverage = json["open"]["hour"].double!
        }
        
    }
    
    func updateBitcoinLabel ()  {
        bitcoinPriceLabel.text = selectedSymbol + String(bitcoinAverage)
        
    }

}

