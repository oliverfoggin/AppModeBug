import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature {
	@ObservableState
	struct State {
		var appMode: AppMode.State = .verifying(.init())
	}

	enum Action {
		case appMode(AppMode.Action)
	}

	var body: some ReducerOf<Self> {
		Scope(state: \.appMode, action: \.appMode) { AppMode() }

		Reduce<State, Action> { state, action in
			switch action {
			case .appMode(.verifying(.delegate(.resolveTo(.login)))):
				state.appMode = .login(.init())
				return .none

			case .appMode(.verifying(.delegate(.resolveTo(.mainApp)))):
				state.appMode = .mainApp(.init())
				return .none

			case .appMode(.login(.delegate(.login))):
				state.appMode = .verifying(.init())
				return .none

			case .appMode:
				return .none
			}
		}
	}
}

struct ContentView: View {
	let store: StoreOf<AppFeature>

	var body: some View {
		WithPerceptionTracking {
			AppModeView(store: store.scope(state: \.appMode, action: \.appMode))
		}
	}
}

#Preview {
	ContentView(
		store: .init(
			initialState: .init(),
			reducer: { AppFeature() }
		)
	)
}
