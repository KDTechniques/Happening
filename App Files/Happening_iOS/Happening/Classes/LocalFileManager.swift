//
//  LocalFileManager.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-18.
//

import Foundation
import UIKit

class LocalFileManager: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = LocalFileManager()
    
    let folderName = "HappeningImages"
    
    // MARK: INITIALIZER
    init() {
        createFolderIfNeeded()
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: createFolderIfNeeded
    func createFolderIfNeeded() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
                    return
                }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Success Creating Folder. 👍🏻👍🏻👍🏻")
            } catch let error {
                print(error.localizedDescription)
                print("Error Creating Folder. 😕😕😕")
            }
        }
    }
    
    
    // MARK: saveImage
    func saveImage(image: UIImage, name: String) {
        guard
            let data = image.jpegData(compressionQuality: 1.0),
            let path = getPathForImage(name: name) else {
                print("Error Getting Image JPEG Data 😕😕😕")
                return
            }
        
        do {
            try data.write(to: path)
            print("Image Successfully Saved To File Manager. 👍🏻👍🏻👍🏻")
        } catch let error {
            print("Error Saving Image to File Manager. 🙁🙁🙁\n\(error)")
        }
    }
    
    
    // MARK: getPathForImage
    func getPathForImage(name: String) -> URL? {
        guard let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .appendingPathComponent("\(name).jpg") else {
                    print("Error Getting The Path. 😟😟😟")
                    return nil
                }
        
        return path
    }
    
    
    // MARK: getImageFromFileManager
    func getImageFromFileManager(name: String) -> UIImage? {
        guard let path = getPathForImage(name: name)?.path,
              FileManager.default.fileExists(atPath: path) else {
                  print("Path Doesn't Exist in File Manager(No Image). 🥲🥲🥲")
                  return nil
              }
        
        return UIImage(contentsOfFile: path)
    }
    
    
    // MARK: deleteImage
    func deleteImage(name: String){
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
                print("Path Doesn't Exist in File Manager(Can't Delete). 🥲🥲🥲")
                return
            }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("File Has Been Successfully Deleted. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
        } catch let error {
            print("Error Deleting File. 😔😔😔")
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: deleteFolder
    func deleteFolder() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
                    return
                }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Folder Has Been Deleted Successfully. 👍🏻👍🏻👍🏻")
        } catch let error {
            print(error.localizedDescription)
            print("Error Deleting Folder. 😕😕😕")
        }
        
    }
}
