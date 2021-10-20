//
//  ViewController.swift
//  iOS Technical test
//
//  Created by  Stepanok Ivan on 20.10.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var jsonData: RootClass?
    var productTypes: [String] = []
    var selected = [Selected]()
    var filteredProducts: [String] = []
    var selectedProduct: String = ""
    
    struct Selected {
        var type: String?
        var selected: Bool?
    }
    
    @IBOutlet weak var tableDevices: UITableView!
    @IBOutlet weak var tableFilter: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AFRequest.loadData { jsonData in
            self.jsonData = jsonData
            for type in 0...jsonData.devices!.count-1 {
                self.productTypes.append(jsonData.devices![type].productType!)
            }
            self.productTypes = self.productTypes.uniqued()
            for key in 0...self.productTypes.count-1 {
                self.selected.append(Selected(type: self.productTypes[key], selected: true))
            }
            print(self.selected)
            print(self.productTypes)
            self.filterDevices()
            DispatchQueue.main.async {
                guard let street = jsonData.user?.address?.street else {return}
                guard let streetCode = jsonData.user?.address?.streetCode else {return}
                
                self.title = "\(street), \(streetCode)"
                self.tableFilter.reloadData()
                self.tableDevices.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableDevices {
            return filteredProducts.count
        } else {
            return productTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableDevices {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = filteredProducts[indexPath.row]
            return cell } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = productTypes[indexPath.row]
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableFilter {
            print(productTypes[indexPath.row])
            // print(selected[productTypes[indexPath.row]])
            self.selected[indexPath.row].selected!.toggle()
            print(selected)
            
            if selected[indexPath.row].selected == true {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
            filterDevices()
        } else {
            print(indexPath.row)
            print(filteredProducts[indexPath.row])
            selectedProduct = filteredProducts[indexPath.row]
            performSegue(withIdentifier: "goToDevice", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DeviceViewController
        destinationVC.deviceName = selectedProduct
        destinationVC.jsonData = jsonData
    }
    
    
    
    func filterDevices() {
        filteredProducts = []
        var checked:[String] = []
        for type in 0...selected.count-1 {
            if selected[type].selected == true {
                checked.append(selected[type].type!)
            }
        }
        for type in 0...(jsonData?.devices!.count)!-1 {
            if checked.count >= 1 {
                for i in 0...checked.count-1 {
                    if jsonData?.devices![type].productType == checked[i] {
                        filteredProducts.append((jsonData?.devices![type].deviceName )!)
                    }
                }
            }
        }
        tableDevices.reloadData()
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
