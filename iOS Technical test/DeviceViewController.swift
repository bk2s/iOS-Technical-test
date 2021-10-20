//
//  DeviceViewController.swift
//  iOS Technical test
//
//  Created by  Stepanok Ivan on 20.10.2021.
//

import UIKit

class DeviceViewController: UIViewController {
    
    @IBOutlet weak var maxValue: UILabel!
    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var slider: UISlider! {
        didSet{
            slider.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        }
    }
    @IBOutlet weak var degress: UILabel!
    @IBOutlet weak var powerType: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    var deviceName = ""
    var jsonData: RootClass?
    var selectedNumber = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        slider.setThumbImage(UIImage(named: "slider_thumb_selected"), for: .highlighted)
        title = deviceName
        deviceNum()
        print(jsonData?.devices![selectedNumber])
        loadDevice()
    }
    
    
    func deviceNum() {
        for device in 0...(jsonData?.devices!.count)!-1 {
            if self.jsonData?.devices![device].deviceName == deviceName {
                break
            }
            selectedNumber += 1
        }
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let type = jsonData?.devices![selectedNumber].productType
        if type == "Heater" {
            let step: Float = 5
            let roundedValue = round(sender.value / step) * step
            sender.value = roundedValue
        }
        degress.text = String(Int(sender.value))
        // loadDevice()
    }
    
    
    
    
    func loadDevice() {
        guard let type = jsonData?.devices![selectedNumber].productType! else { return}
        guard let device = jsonData?.devices![selectedNumber] else {return}
        let mode = jsonData?.devices![selectedNumber].mode
        switch mode {
        case "ON" :
            switcher.isOn = true
        case "OFF" :
            switcher.isOn = false
        default:
            switcher.isHidden = true
        }
        switch type {
        case "RollerShutter" :
            print("RollerShutter")
            minValue.text = "0"
            maxValue.text = "100"
            slider.minimumValue = 0
            slider.maximumValue = 100
            slider.value = Float((device.position!))
            powerType.text = "Position:"
            degress.text = String((device.position!))
            switcher.isHidden = true
        case "Light" :
            minValue.text = "0"
            maxValue.text = "100"
            slider.minimumValue = 0
            slider.maximumValue = 100
            slider.value = Float((device.intensity!))
            powerType.text = "Intensity:"
            degress.text = String((device.intensity!))
        case "Heater" :
            minValue.text = "7"
            maxValue.text = "28"
            slider.minimumValue = 7
            slider.maximumValue = 28
            slider.value = Float((device.temperature!))
            powerType.text = "Temperature:"
            degress.text = String((device.temperature!))
        default:
            print("Nothing")
        }
    }
}
