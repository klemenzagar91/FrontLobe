//
//  MainVC.swift
//  Front Lobe
//
//  Created by Klemen Zagar on 2/22/17.
//  Copyright © 2017 Klemen Zagar. All rights reserved.
//

import Cocoa

class MainVC: NSViewController, DestinationViewDelegate {
  @IBOutlet var dropView: DropProjectView!
  @IBOutlet weak var projectPathLabel: NSTextField!
  var projectURL: URL? {
    didSet {
      projectPathLabel.stringValue = projectURL?.path ?? ""
    }
  }

    override func viewDidLoad() {
      super.viewDidLoad()
      dropView.delegate = self
      
        // Do view setup here.
    }
  
  @IBAction func handleCreateGemfileButton(_ sender: NSButton) {
    print("hello")
    if let projectURL = projectURL {
      runScript(["cd", projectURL.path]) {
        print("step 1")
        self.runScript(["-c", "bundle", "init"], handler: {
          print("step 2")
        })
      }
//      let pipe = Pipe()
//      let process = Process()
//      process.launchPath = "/bin/bash"
//      process.arguments = ["cd", projectURL.path]
//      process.standardOutput = pipe
//      let file = pipe.fileHandleForReading
//      process.launch()
//      
//      
//      if let result = String(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8) {
//        print(result)
//      }
//      else {
//        print("error")
//      }
    }
  }
  
  
  func runScript(_ arguments:[String], handler:@escaping () -> ()) {
    let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    taskQueue.async {
      let buildTask = Process()
      buildTask.launchPath = "/bin/bash"
      buildTask.arguments = arguments
      
      buildTask.terminationHandler = {
        task in
        DispatchQueue.main.async(execute: {
          handler()
        })
      }
      buildTask.launch()
      buildTask.waitUntilExit()
    }
    
  }
  
  func processImage(_ image: NSImage, center: NSPoint) {

  }
  
  func processImageURLs(_ url: URL, center: NSPoint) {
    print("hello", url);
    projectURL = url
  }
  
  func processAction(_ action: String, center: NSPoint) {
    
  }
}
