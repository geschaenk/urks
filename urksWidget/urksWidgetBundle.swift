//
//  urksWidgetBundle.swift
//  urksWidget
//
//  Created by Hölscher, Frank on 26.03.26.
//

import WidgetKit
import SwiftUI

@main
struct urksWidgetBundle: WidgetBundle {
    var body: some Widget {
        urksWidget()
        urksWidgetControl()
        urksWidgetLiveActivity()
    }
}
