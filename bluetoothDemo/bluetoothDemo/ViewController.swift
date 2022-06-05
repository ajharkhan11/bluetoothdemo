//
//  ViewController.swift
//  bluetoothDemo
//
//  Created by Ajharudeen Khan on 25/05/22.
//

import UIKit
import CoreBluetooth

let heartRateServiceCBUUID = CBUUID(string: "0x180D")
let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")

class ViewController: UIViewController, CBCentralManagerDelegate , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var devices = [CBPeripheral]()
    
    var centralManager: CBCentralManager!
//    var heartRatePeripheral: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
      switch central.state {
      case .unknown:
        print("central.state is .unknown")
      case .resetting:
        print("central.state is .resetting")
      case .unsupported:
        print("central.state is .unsupported")
      case .unauthorized:
        print("central.state is .unauthorized")
      case .poweredOff:
        print("central.state is .poweredOff")
      case .poweredOn:
        print("central.state is .poweredOn")
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "FFF0"), CBUUID(string: "FFE0")])
      @unknown default:
          print("Unkown");
      }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
      print(peripheral)
        print(peripheral.services)
        devices.append(peripheral)
//      heartRatePeripheral = peripheral
        
//      heartRatePeripheral.delegate = self
      tableView.reloadData()
//      centralManager.stopScan()
//      centralManager.connect(heartRatePeripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
      print("Connected!")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
//                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic.value?.first)
//        peripheral.writeValue((characteristic.value)!, for: characteristic, type: .withResponse)
        
        Optional(92)
        Optional(77)
        Optional(83)
        Optional(70)
        Optional(72)
        Optional(83)
        Optional(77)
        Optional(254)
        Optional(1)
        Optional(1)
        Optional(2)
        Optional(1)
        Optional(0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.textLabel?.text = devices[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        centralManager.connect(devices[indexPath.row])
        
        
    }
    
}


