# EasyNetworking

This is a simple wrapper around `URLSession` to make its usage more lightweight. All awesome features (for example thread-safety) are therefore included.

## Features

* Data and upload task handling, optional response parsing to `Decodable`-s.
* Returns `Combine` publishers, therefore your view model-s can subscribe to the results by using  `.sink`.
* It uses the default `URLSession.shared`, but you can pass your own session to it as well.

## What is not included

Custom features are not added to the library, but since you can pass your own `URLSession`,  delegate logic can be added on the client-side. Some examples: session delegate handling, caching, handling authentication challenges, certificate pinning.

## Integration

Select your main project. On the Swift packages tab, tap on the `+` icon to add a new dependency. Enter `git@github.com:tamasdancsi/ios-easy-networking.git`, hit next twice and you're ready to go.

## Usage

An example project can be found in the `Example` folder.

1. Create an `APIClient` instance. By default it uses the `URLSession.shared` singleton but you can pass your own instance as well in case you want to go custom. Similarly with the `jsonDecoder` param which defaults to a regular `JSONDecoder` instance.

```swift
import SwiftUI
import Combine
import EasyNetworking

class ContentViewModel: ObservableObject {

    @Published var todos: [Todo] = []

    private lazy var apiClient: APIClient = {
        APIClient(baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
    }()

    private var cancellables: Set<AnyCancellable> = []
}
```

2. Prepare your `API` requests with flexible `RequestConfiguration`-s.

```swift
private func updateTodo(todo: Todo) -> AnyPublisher<TodoUpdateResult, Error> {
    do {
        let configuration = RequestConfiguration(endpointPath: "/todos/\(todo.id)",
                                                  method: .put,
                                                  body: .params(try todo.asDictionary()))
        return apiClient.request(configuration: configuration)
    } catch {
        return Fail(error: error).eraseToAnyPublisher()
    }
}

private func getTodos() -> AnyPublisher<[Todo], Error> {
    let configuration = RequestConfiguration(endpointPath: "/todos")
    return apiClient.request(configuration: configuration)
}
```

3. Then you can send your requests by subscribing to the returned `AnyPublisher`-s with `.sink`.

```swift
getTodos()
    .sink { [weak self] completion in
        // Handle completion
    } receiveValue: { [weak self] todos in
        // Handle received values
    }
    .store(in: &cancellables)
```

```swift
updateTodo(todo: updatedTodo)
    .sink { [weak self] completion in
        // Handle completion
    } receiveValue: { [weak self] result in
        // Handle received values
    }
    .store(in: &cancellables)
```
