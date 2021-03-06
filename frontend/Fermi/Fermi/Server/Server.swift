//
//  Server.swift
//  Fermi
//
//  Created by Elliott Bolzan on 11/15/18.
//  Copyright © 2018 Davis Booth. All rights reserved.
//

import Foundation
import Alamofire
import FacebookCore

class Server {
    
    class func headers() -> [String: String] {
        return [
            "Authorization": AccessToken.current?.authenticationToken ?? "",
            "id": String(User.shared.person?.id ?? -1)
        ]
    }
    
}

// Profile-related.
extension Server {
    
    class func profilePicture(id: Int, completion: @escaping (UIImage?) -> Void) {
        let profilePictureURL = "http://graph.facebook.com/\(id)/picture?type=large"
        Alamofire.request(profilePictureURL, method: .get).responseImage { response in
            guard let image = response.result.value else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
    
}

// User-related.
extension Server {
    
    public class func getUser(id: Int, completion: @escaping (Person) -> Void) {
        let uri = Constants.host + "user/" + String(id)
        Alamofire.request(uri, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers()).validate().responseJSON { response in
            guard response.result.isSuccess,
                let response = response.result.value as? [String: Any] else {
                    return
            }
            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
            let decoded = String(data: data, encoding: .utf8)!
            completion(Person.from(json: decoded))
        }
    }
    
    public class func createUser(id: Int, name: String, token: String, completion: @escaping (Person) -> Void) {
        let uri = Constants.host + "user/create"
        let parameters: [String: Any] = [
            "id": id,
            "name": name,
            "token": token
        ]
        Alamofire.request(uri, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            guard response.result.isSuccess,
                let response = response.result.value as? [String: Any] else {
                    return
            }
            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
            let decoded = String(data: data, encoding: .utf8)!
            completion(Person.from(json: decoded))
        }
    }
    
    public class func updateUser(person: Person, completion: @escaping (Person) -> Void) {
        let uri = Constants.host + "user/update"
        Alamofire.request(uri, method: HTTPMethod.post, parameters: person.toJSON(), encoding: JSONEncoding.default, headers: headers()).validate().responseJSON { response in
            guard response.result.isSuccess,
                let response = response.result.value as? [String: Any] else {
                    return
            }
            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
            let decoded = String(data: data, encoding: .utf8)!
            completion(Person.from(json: decoded))
        }
    }
    
    public class func getUsersWith(filter: Filter, completion: @escaping ([Person]) -> Void) {
        let uri = Constants.host + "user/filter"
        var users = [Person]()
        Alamofire.request(uri, method: HTTPMethod.post, parameters: filter.toJSON(), encoding: JSONEncoding.default, headers: headers()).validate().responseJSON { response in
            guard response.result.isSuccess,
                let response = response.result.value as? [[String: Any]] else {
                    return
            }
            for entry in response {
                let data = try! JSONSerialization.data(withJSONObject: entry, options: [])
                let decoded = String(data: data, encoding: .utf8)!
                let person = Person.from(json: decoded)
                if person.id != User.shared.person!.id {
                    users.append(person)
                }
            }
            completion(users)
        }
    }
    
}

// Referral-related.
extension Server {
    
    public class func createReferral(sender: Int, recipient: Int, status: Status, completion: @escaping (Referral) -> Void) {
        let uri = Constants.host + "referrals/create"
        let parameters: [String: Any] = [
            "sender": sender,
            "recipient": recipient,
            "status": status.rawValue
        ]
        Alamofire.request(uri, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers()).validate().responseJSON { response in
            guard response.result.isSuccess,
                let response = response.result.value as? [String: Any] else {
                    return
            }
            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
            let decoded = String(data: data, encoding: .utf8)!
            completion(Referral.from(json: decoded))
        }
    }
    
    public class func updateReferral(referral: Referral, completion: @escaping (Referral) -> Void) {
        let uri = Constants.host + "referrals/update"
        Alamofire.request(uri, method: HTTPMethod.post, parameters: referral.toJSON(), encoding: JSONEncoding.default, headers: headers()).validate().responseJSON { response in
            guard response.result.isSuccess,
                let response = response.result.value as? [String: Any] else {
                    return
            }
            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
            let decoded = String(data: data, encoding: .utf8)!
            completion(Referral.from(json: decoded))
        }
    }
    
    public class func getReferralsFor(id: Int, completion: @escaping ([Referral], [Referral]) -> Void) {
        let uri = Constants.host + "referrals/forUser/" + String(id)
        Alamofire.request(uri, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers()).validate().responseJSON { response in
            guard response.result.isSuccess,
                let response = response.result.value as? [[String: Any]] else {
                    return
            }
            var referredMe = [Referral]()
            var referredThem = [Referral]()
            for entry in response {
                let data = try! JSONSerialization.data(withJSONObject: entry, options: [])
                let decoded = String(data: data, encoding: .utf8)!
                let referral = Referral.from(json: decoded)
                if referral.iAmSender() {
                    referredThem.append(referral)
                }
                else {
                    referredMe.append(referral)
                }
            }
            completion(referredMe, referredThem)
        }
    }
    
}
