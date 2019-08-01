import Foundation

// DART messges:
// MoN America Ch 1: whenenteringstrangehotelsalwayscheckthebathroom
// Colour Out of Space: themeteoritecraterwellandhouseinthenewspaperphotowerespeciallybuiltminiaturesthehousewaslaterusedinthewitchhousemusicvideo
// Dagon:
//[1,22,23,1,3,2,1,4,13,1,14,1,9,17,22,17,3,1,2,10,15,2,17,14,12,18,14,3,1,2,3,17,18,7,6,
//26,2,17,18,7,3,16,8,23,17,11,17,22,13,1,2,1,18,6,13,1,14,1,20,8,6,8,2,1,22,15,8,18,17,
//3,8,18,3,17,1,2,10,20,12,2,20,8,13,8,2,3,16,1,18,3,16,17,2,3,10,10,8,1,2,14]
// alcatrazwasamilitaryprisonstartingduringthecivilwarandwasafederalpenitentiaryforfewerthanthirtyyears
// W3 message
//httpswwwfacebookdotcomslashgroupsslashslashjoinifyoudare
//[
//6,19,19,5,4,3,3,3,10,17,13,24,11,2,2,14,22,2,19,13,2,25,
//4,12,17,4,6,23,18,2,16,5,4,4,12,17,4,6,
//4,12,17,4,6,21,2,7,8,7,10,26,2,16,22,17,18,24
//]
// 8/1/2019 message
// livedartshowsinprovidencewillincludespecialaudiencgparticiption
// wethinkitwillbefunifyouseeandrewthereprivatelysayconstantinople
//[
//22,17,11,8,6,1,2,3,14,16,12,13,14,17,18,15,2,12,11,17,
//6,8,18,23,8,13,17,22,22,17,18,23,22,26,6,8,14,15,8,23,
//17,1,22,1,26,6,17,8,18,23,7,15,1,2,3,17,23,17,15,
//3,17,12,18,13,8,3,16,17,18,24,17,3,13,17,22,22,21,8,
//20,26,18,17,20,10,12,26,14,8,8,1,18,6,2,8,13,3,16,8,2,
//8,15,2,17,11,1,3,8,22,10,14,1,10,
//23,12,18,14,3,1,18,3,17,18,12,15,22,8
//]

// Works with Caesar Ciphers. https://en.wikipedia.org/wiki/Caesar_cipher
// DART uses "blckquartzjdgemyvowsphinxf"
// Little Orphan Annie (1935) used "okcqxjdrwiesvhgtfupamznbly"
struct DARTDecoder {
    let offset: Int
    let startCharacter: Character
    static let letters = "blckquartzjdgemyvowsphinxf"
    lazy var startIndex = DARTDecoder.letters.firstIndex(of: startCharacter)!
    lazy var firstHalf = DARTDecoder.letters[startIndex..<DARTDecoder.letters.endIndex]
    lazy var secondHalf = DARTDecoder.letters[DARTDecoder.letters.startIndex..<startIndex]
    lazy var reordered = firstHalf + secondHalf

    public init(offset: Int, startCharacter: Character) {
        self.offset = offset
        self.startCharacter = startCharacter
    }

    private mutating func char4index(_ idx: Int, _ offs: Int) -> Character {
        var index = idx - offs
        if index >= 26 { index -= 26 }
        if index < 0 { index += 26 }
        return reordered[String.Index(utf16Offset: index, in: reordered)]
    }

    public mutating func decode(_ message: [Int]) -> String {
        var out = ""
        for idx in message {
            out.append(char4index(idx, offset))
        }
        return out
    }

    public static func scanForMessage(_ message: [Int]) -> [String] {
        var strings: [String] = []

        for each in 1...26 {
            var decoder = DARTDecoder(offset: each, startCharacter: "a")
            strings.append(decoder.decode(message))
        }

        return strings
    }

}

let message = [9,7,2]
let messages = DARTDecoder.scanForMessage(message)
let wordsFileURL = Bundle.main.url(forResource: "words", withExtension: "json")!
let words = try! Data(contentsOf: wordsFileURL)
let allWords: [String] = try! JSONDecoder().decode(Array<String>.self, from: words)

var counts: [String:Int] = [:]

messages.forEach { counts[$0] = 0 }

for word in allWords {
    let incrementers = messages.filter { $0.contains(word) }
    incrementers.forEach { counts[$0] = counts[$0]! + 1 }
}

let zipped = zip(counts.keys, counts.values)
let sorted = zipped.sorted { $1.1 < $0.1 }
print("\(sorted.first?.0 ?? "no obvious message")")

