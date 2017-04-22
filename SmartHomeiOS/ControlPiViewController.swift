//
//  ControlPiViewController.swift
//  SmartHomeiOS
//
//  Created by Sukhjot Bassi on 4/22/17.
//  Copyright © 2017 Sukhjot Bassi. All rights reserved.
//

import Foundation
import UIKit

class ControlPiViewController: UIViewController, StreamDelegate {
    
    //Button
    //var buttonConnect : UIButton!
    
    @IBOutlet var buttonConnect: UIButton!
    @IBOutlet var buttonOpen: UIButton!
    @IBOutlet var buttonClose: UIButton!
    
    //Label
    var label : UILabel!
    var labelConnection : UILabel!
    
    //Socket server
    let addr = "192.168.2.2"
    let port = 9876
    
    //Network variables
    var inStream : InputStream?
    var outStream: OutputStream?
    
    //Data received
    var buffer = [UInt8](repeating: 0, count: 200)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ButtonSetup()
        
        LabelSetup()
    }
    
    //Button Functions
    func ButtonSetup() {
//        buttonConnect = UIButton(frame: CGRect(x: 20, y: 50, width: 300, height: 30))
//        buttonConnect.setTitle("Connect to server", for: UIControlState())
//        buttonConnect.setTitleColor(UIColor.blue, for: UIControlState())
//        buttonConnect.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        buttonConnect.addTarget(self, action: "btnConnectPressed:", for: UIControlEvents.touchUpInside)
        //view.addSubview(buttonConnect)
//        
//        let buttoniPhone = UIButton(frame: CGRect(x: 20, y: 100, width: 300, height: 30))
//        buttoniPhone.setTitle("Send \"This is iPhone\"", for: UIControlState())
//        buttoniPhone.setTitleColor(UIColor.blue, for: UIControlState())
//        buttoniPhone.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        buttonOpen.addTarget(self, action: "btnOpenPressed:", for: UIControlEvents.touchUpInside)
        //view.addSubview(buttoniPhone)
        
        
        buttonClose.addTarget(self, action: "btnClosePressed:", for: UIControlEvents.touchUpInside)
        
        
        
//        let buttonQuit = UIButton(frame: CGRect(x: 20, y: 150, width: 300, height: 30))
//        buttonQuit.setTitle("Send \"Quit\"", for: UIControlState())
//        buttonQuit.setTitleColor(UIColor.blue, for: UIControlState())
//        buttonQuit.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
//        buttonQuit.addTarget(self, action: "btnQuitPressed:", for: UIControlEvents.touchUpInside)
//        view.addSubview(buttonQuit)
    }
    
    func btnConnectPressed(_ sender: UIButton) {
        NetworkEnable()
        
        buttonConnect.alpha = 0.3
        buttonConnect.isEnabled = false
        buttonConnect.setTitleColor(UIColor.blue, for: UIControlState())
    }
    func btnOpenPressed(_ sender: UIButton) {
        let data : Data = "On".data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
    }
    
    func btnClosePressed(_ sender: UIButton) {
        let data : Data = "Off".data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
    }
    
//    func btnQuitPressed(_ sender: UIButton) {
//        let data : Data = "Quit".data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//    }
    //Label setup function
    func LabelSetup() {
        label = UILabel(frame: CGRect(x: 0,y: 0,width: 300,height: 150))
        label.center = CGPoint(x: view.center.x, y: view.center.y+100)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0 //Multi-lines
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        view.addSubview(label)
        
        labelConnection = UILabel(frame: CGRect(x: 0,y: 0,width: 300,height: 30))
        labelConnection.center = view.center
        labelConnection.textAlignment = NSTextAlignment.center
        labelConnection.text = "Please connect to server"
        view.addSubview(labelConnection)
    }
    
    //Network functions
    func NetworkEnable() {
        
        print("NetworkEnable")
        Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inStream, outputStream: &outStream)
        
        inStream?.delegate = self
        outStream?.delegate = self
        
        inStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        outStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        inStream?.open()
        outStream?.open()
        
        buffer = [UInt8](repeating: 0, count: 200)
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        switch eventCode {
        case Stream.Event.endEncountered:
            print("EndEncountered")
            labelConnection.text = "Connection stopped by server"
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            outStream?.close()
            print("Stop outStream currentRunLoop")
            outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            buttonConnect.alpha = 1
            buttonConnect.isEnabled = true
        case Stream.Event.errorOccurred:
            print("ErrorOccurred")
            
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            outStream?.close()
            outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            labelConnection.text = "Failed to connect to server"
            buttonConnect.alpha = 1
            buttonConnect.isEnabled = true
            label.text = ""
        case Stream.Event.hasBytesAvailable:
            print("HasBytesAvailable")
            
            if aStream == inStream {
                inStream!.read(&buffer, maxLength: buffer.count)
                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                label.text = bufferStr! as String
                print(bufferStr!)
            }
            
        case Stream.Event.hasSpaceAvailable:
            print("HasSpaceAvailable")
        case Stream.Event():
            print("None")
        case Stream.Event.openCompleted:
            print("OpenCompleted")
            labelConnection.text = "Connected to server"
        default:
            print("Unknown")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
}
