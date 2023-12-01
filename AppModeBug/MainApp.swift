import ComposableArchitecture
import SwiftUI

@Reducer
struct MainApp {
	@ObservableState
	struct State {
		var text: String = "Welcome User"
	}

	enum Action {
		case onAppear
		case sheetButtonPressed
		case delegate(Delegate)

		@CasePathable enum Delegate {
			case showFullScreen
		}
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .onAppear:
				print("Main App on appear")
				return .none

			case .sheetButtonPressed:
				return .send(.delegate(.showFullScreen))

			case .delegate:
				return .none
			}
		}
	}
}

struct MainAppView: View {
	@State var store: StoreOf<MainApp>

	var body: some View {
		WithPerceptionTracking {
			VStack {
				Text(store.text)

				Button {
					store.send(.sheetButtonPressed)
				} label: {
					Text("Tap to show full screen cover")
				}
			}
			.onAppear { store.send(.onAppear) }
		}
	}
}
