import SwiftUI

struct FullCastListView: View {
    
    enum CastType: Int, CaseIterable, Identifiable {
        case cast = 0
        case crew = 1
        var title: String {
            switch self {
            case .cast:
                "Cast"
            case .crew:
                "Crew"
            }
        }
        
        var id: Int {
            rawValue
        }
    }
    
    let cast: MovieCastApiResponseModel
    
    @State private var selectedType: CastType = .cast
    
    var body: some View {
        List {
            Picker("Cast or Crew", selection: $selectedType) {
                ForEach(CastType.allCases) { type in
                    Text(type.title)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            listItems(
                for: selectedType == .cast ? cast.cast : cast.crewSorted
            )
        }
        .inlineNavigationTitle("Full \(selectedType.title)")
    }
    
    func listItems(for models: [MovieCastApiModel]) -> some View {
        ForEach(models) { model in
            CastCardView(
                imagePath: model.profilePath,
                title: model.name,
                subtitle: selectedType == .cast ? model.character : model.job
            )
        }
    }
}

#Preview {
    NavigationStack {
        FullCastListView(
            cast: try! StaticJSONMapper.decode(
                file: MovieEndpoint.cast(movieId: 299534).stubDataFilename!,
                type: MovieCastApiResponseModel.self
            )
        )
    }
}
