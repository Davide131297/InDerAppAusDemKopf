import SwiftUI

@main
struct InDerAppAusDemKopfApp: App {
    @StateObject private var store = MemoStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
