import ComposableArchitecture
import SwiftUI

@Reducer
struct AppMode {
	@ObservableState
	enum State {
		case verifying(Verifying.State)
		case login(Login.State)
		case mainApp(MainApp.State)
	}

	enum Action {
		case verifying(Verifying.Action)
		case login(Login.Action)
		case mainApp(MainApp.Action)
	}

	public var body: some ReducerOf<Self> {
		Scope(state: \.verifying, action: \.verifying) { Verifying() }
		Scope(state: \.login, action: \.login) { Login() }
		Scope(state: \.mainApp, action: \.mainApp) { MainApp() }
	}
}

struct AppModeView: View {
	let store: StoreOf<AppMode>

	var body: some View {
		WithPerceptionTracking {
			switch store.state {
			case .verifying:
				if let store = store.scope(state: \.verifying, action: \.verifying) {
					VerifyingView(store: store)
				}

			case .mainApp:
				if let store = store.scope(state: \.mainApp, action: \.mainApp) {
					MainAppView(store: store)
				}

			case .login:
				if let store = store.scope(state: \.login, action: \.login) {
					LoginView(store: store)
				}
			}
		}
	}
}
