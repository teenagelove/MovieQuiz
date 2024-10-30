import Foundation


struct GameRecord {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
