import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature {
	@CasePathable @dynamicMemberLookup enum Destination {
		case fullScreen(FullScreenFeature.State)
	}
	
	@ObservableState
	struct State {
		var appMode: AppMode.State = .verifying(.init())
		@Presents var destination: Destination?
	}

	enum Action {
		case appMode(AppMode.Action)

		case destination(PresentationAction<Destination>)
		
		@CasePathable public enum Destination {
			case fullScreen(FullScreenFeature.Action)
		}
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

			case .appMode(.mainApp(.delegate(.showFullScreen))):
				state.destination = .fullScreen(.init())
				return .none

			case .appMode, .destination:
				return .none
			}
		}
		.ifLet(\.$destination, action: \.destination) {
			Scope(state: \.fullScreen, action: \.fullScreen) {
				FullScreenFeature()
			}
		}
	}
}

struct ContentView: View {
	@State var store: StoreOf<AppFeature>

	var body: some View {
		WithPerceptionTracking {
			AppModeView(store: store.scope(state: \.appMode, action: \.appMode))
				.fullScreenCover(item: $store.scope(state: \.destination?.fullScreen, action:  \.destination.fullScreen)) {
					FullScreenFeatureView(store: $0)
				}
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
