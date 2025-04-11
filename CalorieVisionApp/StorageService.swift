swift
import UIKit
import Firebase
import FirebaseStorage

class StorageService{
    func uploadImage(image: UIImage, userId: String) async -> String{
        let storageRef = Storage.storage().reference()

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return ""
            }
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("users/\(userId)/meals/\(imageName).jpg")
        
        do {
            _ = try await imageRef.putDataAsync(imageData)
            let url = try await imageRef.downloadURL().absoluteString
            return url
        } catch {
            print("Error uploading image: \(error)")
            return ""
        }

    }
}