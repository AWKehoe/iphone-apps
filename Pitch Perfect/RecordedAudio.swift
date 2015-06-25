//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Anthony Kehoe on 01/06/2015.
//  Copyright (c) 2015 Anthony Kehoe. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL?
    var title: String?
    
    init (filePath: NSURL, title: String) {
        self.filePathUrl = filePath
        self.title = title
    }
}