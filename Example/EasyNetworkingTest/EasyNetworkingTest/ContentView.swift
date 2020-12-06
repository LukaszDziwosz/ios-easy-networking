//
//  Copyright © 2020 Tamas Dancsi. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        renderList()
                    }
                }
                .navigationBarTitle("Todos: \(viewModel.todos.count)")

                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.9))
                }
            }
        }
        .onAppear {
            viewModel.fetchTodos()
        }
    }

    // MARK: - Helpers

    private func renderList() -> some View {
        ForEach(viewModel.todos) { todo in
            VStack(alignment: .leading) {
                HStack {
                    Text(todo.title)
                    Spacer()
                    Image(systemName: todo.completed ? "checkmark.circle" : "circle")
                        .font(Font.system(.title2).bold())
                        .foregroundColor(todo.completed ? .green : .black)
                }
                .padding()
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.onTap(todo: todo)
                }

                Divider()
            }
        }
    }
}
