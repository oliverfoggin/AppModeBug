import ComposableArchitecture
import SwiftUI

@Reducer
struct FullScreenFeature {
	@ObservableState
	struct State {
		var text: String = "Fullscreem Feature"
	}

	enum Action {
		case dismissButtonTapped
	}

	@Dependency(\.dismiss) var dismiss

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .dismissButtonTapped:
				return .run { _ in
					await dismiss()
				}
			}
		}
	}
}

struct FullScreenFeatureView: View {
	let store: StoreOf<FullScreenFeature>

	var body: some View {
		WithPerceptionTracking {
			VStack {
				Text(store.text)

				Button {
					store.send(.dismissButtonTapped)
				} label: {
					Text("Tap to dismiss")
				}
			}
		}
	}
}
