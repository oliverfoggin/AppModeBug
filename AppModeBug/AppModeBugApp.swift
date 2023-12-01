import SwiftUI
import ComposableArchitecture

@main
struct AppModeBugApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView(
				store: .init(
					initialState: .init(),
					reducer: { AppFeature()._printChanges() }
				)
			)
		}
	}
}
