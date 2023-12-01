import ComposableArchitecture
import SwiftUI

@Reducer
struct Login {
	@ObservableState
	struct State {
		var text: String = "Login"
	}

	enum Action {
		case onAppear
		case loginButtonTapped
		case delegate(Delegate)

		@CasePathable enum Delegate {
			case login
		}
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .loginButtonTapped:
				return .send(.delegate(.login))

			case .delegate:
				return .none

			case .onAppear:
				print("Login on appear")
				return .none
			}
		}
	}
}

struct LoginView: View {
	let store: StoreOf<Login>

	var body: some View {
		WithPerceptionTracking {
			VStack {
				Text(store.text)

				Button {
					store.send(.loginButtonTapped)
				} label: {
					Text("Tap to Login")
				}
			}
			.onAppear { store.send(.onAppear) }
		}
	}
}
