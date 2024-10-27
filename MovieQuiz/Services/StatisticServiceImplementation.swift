import Foundation

final class StatisticServiceImplementation {
    private let storage: UserDefaults = .standard
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: "correctAnswers")
        }
        set {
            storage.set(newValue, forKey: "correctAnswers")
        }
    }
    private enum Keys: String {
        case correct
        case bestGames
        case gamesCount
        case total
        case date
        case totalAccuracy
    }
}

extension StatisticServiceImplementation: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            return GameRecord(
                correct: storage.integer(forKey: Keys.correct.rawValue),
                total: storage.integer(forKey: Keys.total.rawValue),
                date: storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if gamesCount == 0 { return 0 }
        return (Double(correctAnswers)/(Double(gamesCount) * 10) * 100)
    }
    
    func store(gameResult game: GameRecord) {
        correctAnswers += game.correct
        gamesCount += 1
        
        if game.isBetterThan(bestGame) {
            bestGame.correct = game.correct
            bestGame.total = game.total
            bestGame.date = game.date
        }
    }
}
