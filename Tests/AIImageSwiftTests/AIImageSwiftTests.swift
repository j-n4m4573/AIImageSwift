import XCTest
@testable import AIImageSwift

final class AIImageSwiftTests: XCTestCase {
    func testSaveImage() {
        let image = UIImage(named: "testImage")!
        let imageGenerator = SwiftAIImage(config: Configuration(apiKey: "apikey", modelID: "modelid"))
        imageGenerator.saveImage(image: image, name: "testImage")
    
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(documentsPath)/testImage.jpeg"
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath))
    }
}
