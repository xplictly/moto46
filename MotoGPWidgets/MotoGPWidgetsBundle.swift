import WidgetKit
import SwiftUI

@main
struct MotoGPWidgetsBundle: WidgetBundle {
    var body: some Widget {
        CalendarWidget()
        DriverWidget()
        ConstructorWidget()
    }
}
