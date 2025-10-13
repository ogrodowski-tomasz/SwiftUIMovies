import Foundation

extension Sequence where Element == MovieCastApiModel {
    func mergedById() -> [MovieCastApiModel] {
        
        let grouped = Dictionary(grouping: self, by: \.id)
        let merged = grouped.values.compactMap { group -> MovieCastApiModel? in
            guard let first = group.first else { return nil }
            let jobs = Set(group.compactMap { $0.job?.trimmingCharacters(in: .whitespacesAndNewlines) }).sorted()
            
            let combinedJobs = jobs.joined(separator: " / ")
            
            let mostPopular = group.max(by: { ($0.popularity ?? 0) < ($1.popularity ?? 0) })
            
            return MovieCastApiModel(
                adult: first.adult,
                id: first.id,
                name: first.name,
                profilePath: mostPopular?.profilePath ?? first.profilePath,
                character: first.character,
                knownForDepartment: first.knownForDepartment,
                popularity: mostPopular?.popularity ?? first.popularity,
                job: combinedJobs
            )
            
        }
        
        return merged.sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }
    }
}
