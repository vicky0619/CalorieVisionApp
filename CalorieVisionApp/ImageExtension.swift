swift
import SwiftUI

extension Image {
    func asUIImage() -> UIImage? {
        if let cgImage = self.asCGImage() {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    func asCGImage() -> CGImage? {
        if let uiImage = self.asUIImage() {
            return uiImage.cgImage
        }
        return nil
    }
}