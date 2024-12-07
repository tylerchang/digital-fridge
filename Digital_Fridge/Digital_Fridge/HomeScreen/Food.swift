//  Created by Simay Cural on 2/10/24.
//
//  This struct makes an instance of a Food object with some variables to be called later by the InventoryView classes.

import Foundation

struct Food: Identifiable{
    var id: String = UUID().uuidString
    var productName: String
    var shelfLifeLength: String
    var shelfLifeMetric: String
    var foodDocumentID: String
}
