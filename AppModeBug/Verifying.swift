import ComposableArchitecture
import SwiftUI

@Reducer
struct Verifying {
	enum Resolution: CaseIterable {
		case login
		case mainApp
	}

	@ObservableState
	struct State {
		var text: String = "Start"
	}

	enum Action {
		case onAppear
		case delegate(Delegate)
		case resolve

		@CasePathable enum Delegate {
			case resolveTo(Resolution)
		}
	}

	@Dependency(\.suspendingClock) var clock

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .onAppear:
				state.text = "On Appear"
				return .send(.resolve)

			case .resolve:
				return .run { send in
					try await clock.sleep(for: .seconds(1))
//					if let resolution = Resolution.allCases.randomElement() {
//						await send(.delegate(.resolveTo(resolution)))
//					}
					await send(.delegate(.resolveTo(.mainApp)))
				}

			case .delegate:
				return .none
			}
		}
	}
}

struct VerifyingView: View {
	let store: StoreOf<Verifying>

	var body: some View {
		WithPerceptionTracking {
			Text(store.text)
				.onAppear { store.send(.onAppear) }
		}
	}
}
