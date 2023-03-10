//
//  AIImageSwift.swift
//  
//
//  Created by Maurice G on 2/28/23.
//

import SwiftUI
import OpenAIKit
#if os(iOS) || os(tvOS)
import UIKit
#endif

@available(macOS 10.15, iOS 14, *)
public enum SwiftAIImageError: Error {
    case openAIError
    case decodingError
    case uploadingError
}

public final class SwiftAIImage {
    private var config: Configuration
    private var openAI: OpenAI?
    
    init(config: Configuration) {
        self.config = config
        self.openAI = OpenAI(config)
    }
    
    public func generateImage(prompt: String, resolution: ImageResolutions, responseFormat: ResponseFormat) async throws -> UIImage {
        
        guard let openAI = openAI else {
            throw SwiftAIImageError.openAIError
        }
        
        do {
            let params = ImageParameters(prompt: prompt, resolution: .medium,
                                         responseFormat: .base64Json)
            let result = try await openAI.createImage(parameters: params)
            let data = result.data[0].image
            let image = try openAI.decodeBase64Image(data)
            return image
        }
        catch {
            throw SwiftAIImageError.openAIError
        }
    }
    
    public func saveImage(image: UIImage, name: String)  {
        let data = image.jpegData(compressionQuality: 1.0)
        let fileName = "\(name).jpeg"
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = url.appendingPathComponent(fileName)
        let filePath = "\(documentsPath)/\(fileName)"
    
        do {
            try data?.write(to: fileURL)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
