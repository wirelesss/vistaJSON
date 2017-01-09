//
//  ViewController.swift
//  VistaJSON
//
//  Created by Rodrigo on 08/01/17.
//  Copyright © 2017 Rodrigo Hernandez. All rights reserved.
//

import UIKit


// El controlador de navegacion va a ser el delegado y también
// va a ser la fuente de datos:
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var labCiudad: UILabel!
    @IBOutlet weak var labTemperatura: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    // Caracas  VEXX0008
    // Paris    FRXX0076
    // Grenoble FRXX0153
    
    // Arreglo de Arreglos:
    var ciudades: Array<Array<String>> = Array<Array<String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.ciudades.append(["Caracas", "VEXX0008"])
        self.ciudades.append(["Paris",   "FRX0076"])
        self.ciudades.append(["Grenoble", "FRX00153"])
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Indicar: El numero de renglones que para el primer y unico componente: igual
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.ciudades.count;
    }
    
    // Indicar: El numero de componentes del pickerView: solo sera 1 (1 sola columna: la ciudad)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.ciudades[row][0]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let urls = "https://query.yahooapis.com/v1/public/yql?format=json&q=SELECT%20*%20FROM%20weather.forecast%20WHERE%20u%20=%20%27c%27%20and%20location%20=%20%27"
        print("Codigo Ciudad:" + self.ciudades[row][1])
        let url = NSURL(string: urls + self.ciudades[row][1] + "%27")
        let datos = NSData(contentsOf: url! as URL)
        print(datos!)
        do {
            let json = try JSONSerialization.jsonObject(with: datos! as Data, options: .mutableLeaves)
            let dico1 =  json as! NSDictionary
            let dico2 = dico1["query"] as! NSDictionary
            if(dico2["results"] != nil){
                if(dico2["results"] != nil){
                    let dico3 = dico2["results"] as! NSDictionary
                    let channel = dico3["channel"] as! NSDictionary
                    let units = channel["units"] as! NSDictionary
                    self.labCiudad.text = units["speed"] as! NSString as String // return "km/h"
                    self.labTemperatura.text = units["temperature"] as! NSString as String // return "C"
                }
            }
            
        }
        catch _ {
            
        }
    }

}

