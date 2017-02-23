//
//  DropProjectView.swift
//  Front Lobe
//
//  Created by Klemen Zagar on 2/22/17.
//  Copyright © 2017 Klemen Zagar. All rights reserved.
//

import Cocoa

protocol DestinationViewDelegate {
  func processImageURLs(_ url: URL, center: NSPoint)
  func processImage(_ image: NSImage, center: NSPoint)
  func processAction(_ action: String, center: NSPoint)
}

class DropProjectView: NSView {
  let filteringOptions = [NSPasteboardURLReadingContentsConformToTypesKey: kUTTypeFolder]
  var acceptableTypes: Set<String> { return [NSURLPboardType] }
  var delegate: DestinationViewDelegate?
  
  func setup() {
    register(forDraggedTypes: Array(acceptableTypes))
  }
  
  override func awakeFromNib() {
    setup()
  }
  
  override func draw(_ dirtyRect: NSRect) {
    
    if isReceivingDrag {
      NSColor.selectedControlColor.set()
      
      let path = NSBezierPath(rect:bounds)
      path.lineWidth = 5.0
      path.stroke()
    }
  }
  
  var isReceivingDrag = false {
    didSet {
      needsDisplay = true
    }
  }
  
  
  
  // Dragging
  func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
    
    var canAccept = false
    
    //2.
    let pasteBoard = draggingInfo.draggingPasteboard()
    
    //3.
    if pasteBoard.canReadObject(forClasses: [NSURL.self]) {
      canAccept = true
    }
    return canAccept
    
  }
  
  override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    let allow = shouldAllowDrag(sender)
    isReceivingDrag = allow
    return allow ? .copy : NSDragOperation()
  }
  
  override func draggingExited(_ sender: NSDraggingInfo?) {
    isReceivingDrag = false
  }
  
  override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
    let allow = shouldAllowDrag(sender)
    return allow
  }
  
  override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
    
    isReceivingDrag = false
    let pasteBoard = draggingInfo.draggingPasteboard()
    
    //2.
    let point = convert(draggingInfo.draggingLocation(), from: nil)
    //3.
    if let urls = pasteBoard.readObjects(forClasses: [NSURL.self]) as? [URL], urls.count > 0 {
      if let url = urls.first {
        delegate?.processImageURLs(url, center: point)
        return true
      }
      
    }
    return false
    
  }
    
}
