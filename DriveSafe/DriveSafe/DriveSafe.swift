//
//  DriveSafe.swift
//  DriverSafeDemo
//
//  Created by Swathy Krishanan on 24/03/17.
//  Copyright © 2017 Attinad. All rights reserved.
//

import UIKit
import CoreBluetooth

public protocol DriveSafeDelegate {
    func refreshPeripheral_Lists(_ peripherals : [CBPeripheral]) -> Void
    func finshedScanning() -> Void
    func receivedMsg(_ message :  String) -> Void
    func didConnect(_ status: Bool) -> Void 
}

public class DriveSafe: NSObject, CBCentralManagerDelegate{
    fileprivate var peripherals:[CBPeripheral] = []
    fileprivate var manager:CBCentralManager? = nil
    public var driveSafeDelegate: DriveSafeDelegate!
    
    
//     startDiscoverDevices()
//     configureDriveSafe
//     connect(BluetoothDevice device)
//     enableBluetooth()
//     sendMesage(String msg)
//     Delegate methods
//     void receivedMsg(String message)
    
    // MARK: -  Public Methods
    
    public func configureDriveSafe() {
        manager = CBCentralManager(delegate: self, queue: nil);
    }
    
    public func getPeripheralCount() -> Int {
        return peripherals.count
    }
    
    public func getAllPheripherals() -> [CBPeripheral] {
        return peripherals
    }
    
    public func getPheripheral(_ id: Int) -> CBPeripheral {
        return peripherals[id]
    }
    
    public func enableBluetooth() { }
    public func sendMesage() { }

    public func connectPheripheral(_ id: Int) -> Void {
        let peripheral = peripherals[id]
        manager?.connect(peripheral, options: nil)
    }
    

    // MARK: -  BLE Scanning

    public func startDiscoverDevices(){
        scanBLEDevices()
    }
    
    
    private func scanBLEDevices() {
        
        manager?.scanForPeripherals(withServices: nil, options: nil)
        
        //stop scanning after 120 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 120.0) {
            self.stopScanForBLEDevices()
            self.driveSafeDelegate.finshedScanning()
        }
    }
    
    private func stopScanForBLEDevices() {
        manager?.stopScan()
    }
    
    
    // MARK: - CBCentralManagerDelegate Methods
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(!peripherals.contains(peripheral)) {
            peripherals.append(peripheral)
        }
        
        // The delegate invoked
        driveSafeDelegate.refreshPeripheral_Lists(peripherals)
    }
    

    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        print("Connected to " +  peripheral.name!)
        driveSafeDelegate.didConnect(true)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        driveSafeDelegate.didConnect(false)
    }

}
