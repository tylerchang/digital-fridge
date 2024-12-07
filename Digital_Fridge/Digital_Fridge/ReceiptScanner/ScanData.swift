//  Created by Simay Cural on 1/24/24.
//
//  This struct serves as a simple container for scanned data, allowing each piece of scanned data to be uniquely identifiable.

import Foundation

struct ScanData:Identifiable {
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
    }
}
