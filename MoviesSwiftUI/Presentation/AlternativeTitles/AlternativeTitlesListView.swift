import SwiftUI

struct AlternativeTitlesListView: View {
    let models: [MovieAlternativeTitlesModel]
    var body: some View {
        List(models) { model in
            Text(model.emoji + " " + model.title)
        }
        .inlineNavigationTitle("Alternative Titles")
    }
}

#Preview {
    NavigationStack {
        AlternativeTitlesListView(models: MovieAlternativeTitlesModel.stubList)
    }
}
