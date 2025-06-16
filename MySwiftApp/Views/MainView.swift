import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.largeTitle)
                .padding()

            Button(action: {
                viewModel.updateTitle()
            }) {
                Text("Update Title")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}