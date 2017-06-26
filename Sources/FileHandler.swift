//
//  FileHandler.swift
//  MyAwesomeProject
//
//  Created by Timothy Barnard on 08/02/2017.
//
//
import PerfectLib
import PerfectHTTP
import MongoDB
import Foundation
import SwiftMoment

/// Defines and returns the Web Authentication routes
public func makeFileUploadRoutes() -> Routes {
    var routes = Routes()
    
    routes.add(method: .post, uri: "/api/{appkey}/upload/{directory}/", handler: uploadFile)
    routes.add(method: .get, uri: "/api/{appkey}/upload/{filepath}/", handler: getFile)
    
    // Check the console to see the logical structure of what was installed.
    print("\(routes.navigator.description)")
    
    return routes
}

func getFile(request: HTTPRequest, _ response: HTTPResponse) {
    
//    guard let apkey = request.urlVariables["appkey"] else {
//        response.appendBody(string: ResultBody.errorBody(value: "no apkey"))
//        response.completed()
//        return
//    }
    
    guard let filepath = request.urlVariables["filepath"] else {
        response.appendBody(string: ResultBody.errorBody(value: "no type"))
        response.completed()
        return
    }
    
    let fileContents = FileController.sharedFileHandler?.getContentsOfFile(filepath)

    response.appendBody(string: fileContents ?? "")
    response.completed()
    
}

func uploadFile(request: HTTPRequest, _ response: HTTPResponse) {
    
    func nowDateTime() -> String {
       let m = moment()
       return m.format()
    }
    
    
    guard let apkey = request.urlVariables["appkey"] else {
        response.appendBody(string: ResultBody.errorBody(value: "no apkey"))
        response.completed()
        return
    }
    
    guard let directory = request.urlVariables["directory"] else {
        response.appendBody(string: ResultBody.errorBody(value: "no type"))
        response.completed()
        return
    }
    
    guard let uploads = request.postFileUploads, uploads.count > 0  else {
        response.appendBody(string: ResultBody.errorBody(value: "uploads empty"))
        response.completed()
        return
    }
    // Create an array of dictionaries which will show what was uploaded
    var ary = [[String:Any]]()
    
    // create uploads dir to store files
    let fileDir = Dir(Dir.workingDir.path + directory)
    do {
        try fileDir.create()
    } catch {
        print(error)
    }
    
    for upload in uploads {
        
        // move file
        let thisFile = File(upload.tmpFileName)
        do {
            let _ = try thisFile.moveTo(path: fileDir.path + upload.fileName, overWrite: true)
        } catch {
            print(error)
        }
        
        let fileObject: [String:String] = [
            "fieldName": upload.fieldName,
            "timestamp": nowDateTime(),
            "fileSize": "\(upload.fileSize)",
            "filePath": fileDir.path + upload.fileName,
            "type": directory
        ]
        
        let objectStr = JSONController.parseJSONToStr(dict: fileObject)
        
        let storage = Storage()
        storage.setAppKey(apkey)
        storage.setCollectionName("Files")
        
        storage.insertDocument(jsonStr: objectStr)

        
        ary.append([
            "fieldName": upload.fieldName,
            "contentType": upload.contentType,
            "fileName": upload.fileName,
            "fileSize": upload.fileSize,
            "tmpFileName": upload.tmpFileName
            ])
        
        
    }
    //values["files"] = ary
    //values["count"] = ary.count

    response.appendBody(string: "")
    response.completed()
}
