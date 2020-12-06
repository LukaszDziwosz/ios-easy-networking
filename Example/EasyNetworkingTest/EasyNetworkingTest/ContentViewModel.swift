//
//  Copyright © 2020 Tamas Dancsi. All rights reserved.
//

import SwiftUI
import Combine
import EasyNetworking

class ContentViewModel: ObservableObject {

    @Published var todos: [Todo] = []
    @Published var isLoading = false

    private lazy var apiClient: APIClient = {
        APIClient(baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
    }()

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Fetching Todos

    func fetchTodos() {
        isLoading = true

        getTodos()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    print("[ContentViewModel] fetching todos error: \(error)")
                }

                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] todos in
                DispatchQueue.main.async {
                    self?.handleFetchTodosSuccess(todos: todos)
                }
            }
            .store(in: &cancellables)
    }

    private func handleFetchTodosSuccess(todos: [Todo]) {
        self.todos = todos.sorted(by: { !$0.completed && $1.completed })
    }

    // MARK: - Updating Todos

    func onTap(todo: Todo) {
        var updatedTodo = todo
        updatedTodo.completed.toggle()

        isLoading = true
        
        updateTodo(todo: updatedTodo)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    print("[ContentViewModel] fetching todos error: \(error)")
                }

                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] result in
                DispatchQueue.main.async {
                    self?.handleUpdateTodoSuccess(todo: updatedTodo, result: result)
                }
            }
            .store(in: &cancellables)
    }

    private func handleUpdateTodoSuccess(todo: Todo, result: TodoUpdateResult) {
        if let index = todos.firstIndex(where: { $0.id == result.id }) {
            todos[index] = todo
        }
    }

    // MARK: - API requests

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
}
