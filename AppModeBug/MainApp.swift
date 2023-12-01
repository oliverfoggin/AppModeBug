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
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .onAppear:
				print("Main App on appear")
				return .none
			}
		}
	}
}

struct MainAppView: View {
	let store: StoreOf<MainApp>

	var body: some View {
		WithPerceptionTracking {
			VStack {
				Text(store.text)
			}
			.onAppear { store.send(.onAppear) }
		}
	}
}
