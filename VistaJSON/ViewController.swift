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
    // Codigos Antiguos
    // Caracas  VEXX0008
    // Paris    FRXX0076
    // Grenoble FRXX0153
    // -----------------------
    // Codigos NUEVOS
    // Caracas  395269
    // Paris    615702
    // Grenoble 593720
    // -----------------------
    // Arreglo de Arreglos:
    var ciudades: Array<Array<String>> = Array<Array<String>>()
    var unidadTemperatura:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.ciudades.append(["Caracas", "395269"])
        self.ciudades.append(["Paris",   "615702"])
        self.ciudades.append(["Grenoble", "593720"])
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        // Select the first row programmatically
        self.pickerView.selectedRow(inComponent: 0)
        self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
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
        /*
         Ejemplo de URL:
         Version Antigua:
         https://query.yahooapis.com/v1/public/yql?format=json&q=SELECT%20*%20FROM%20weather.forecast%20WHERE%20u%20=%20%27c%27%20and%20location%20=%20%27VEXX0008%27
         Nueva Version de query Yahoo:
         https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20=   +  WOEID  +     &format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys
         
         Pagina de documentacion de Yahoo Weather API:
         https://developer.yahoo.com/weather/documentation.html
         
         PASOS:
         1) Ir a http://weather.yahoo.com/
         2) buscar por una ciudad
         3) Ejecutar en consola del navegador
            para obtener el codigo numerico WOEID
            $('div[data-woeid]').getAttribute('data-woeid')
         
         La URL para obtener JSON tiene la siguiente forma:
         http://weather.yahooapis.com/forecastrss?w=location
         donde location sera el codigo WOEID obtenido en paso 3).
         
         Fin.
        */
        let urls = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20="
        print("Codigo Ciudad:" + self.ciudades[row][1])
        
        /* Para Antigua URL:
        let url = NSURL(string: urls + self.ciudades[row][1] + "%27")
        */
        /* Para Nueva URL: */
        let url = NSURL(string: urls + self.ciudades[row][1] + "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
        let datos = NSData(contentsOf: url! as URL)
        print(datos!)
        do {
            let json = try JSONSerialization.jsonObject(with: datos! as Data, options: .mutableLeaves)
            let dico1 =  json as! NSDictionary
            let dico2 = dico1["query"] as! NSDictionary
            if(dico2["results"] != nil){
                if(dico2["results"] != nil){
                    let results = dico2["results"] as! NSDictionary
                    let channel = results["channel"] as! NSDictionary
                    let units = channel["units"] as! NSDictionary
                    let location = channel["location"] as! NSDictionary
                    self.labCiudad.text = location["city"] as! NSString as String
                    unidadTemperatura = units["temperature"] as! NSString as String
                    let item = channel["item"] as! NSDictionary
                    let condition = item["condition"] as! NSDictionary
                    self.labTemperatura.text = condition["temp"] as! NSString as String + unidadTemperatura
                }
            }
            
        }
        catch _ {
            
        }
    }

}

