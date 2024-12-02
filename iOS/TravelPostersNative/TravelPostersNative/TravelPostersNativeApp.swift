import SwiftUI

@main
struct TravelPostersNativeApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black
                CityListView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
