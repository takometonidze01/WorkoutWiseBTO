import Foundation
import SwiftyUserDefaults

protocol IUserDefaultsSettings {
    func changeUserInAppValue(on: Bool)
    func getUserInAppValue() -> Bool
    func changePushAsked(value: Bool)
    func getAskPushValue() -> Bool
    func changeGuest(value: Bool)
    func getGuestValue() -> Bool
}

class UserDefaultsStorage: IUserDefaultsSettings {
    static let shared = UserDefaultsStorage()
    
    private init() {}
    
    func changeUserInAppValue(on: Bool) {
        isUserInApp = on
    }
    
    func getUserInAppValue() -> Bool {
        return isUserInApp
    }
    
    func getAskPushValue() -> Bool {
        return wasPushAsked
    }
    
    func changePushAsked(value: Bool) {
        wasPushAsked = value
    }
    
    func getSignInValue() -> Bool {
        return wasSignIn
    }
    
    func changeSignIn(value: Bool) {
        wasSignIn = value
    }
    
    func getRegisterValue() -> Bool {
        return wasRegister
    }
    
    func getGuestValue() -> Bool {
        return isGuest
    }
    
    func changeRegisterAsked(value: Bool) {
        wasRegister = value
    }
    
    func changeGuest(value: Bool) {
        isGuest = value
    }
    
    private var isGuest: Bool {
        get {
            return Defaults[\.isGuest] ?? false
        }
        
        set {
            Defaults[\.isGuest] = newValue
        }
    }
    
    private var isUserInApp: Bool {
        get {
            return Defaults[\.isItTheFirstLaunch] ?? false
        }
        
        set {
            Defaults[\.isItTheFirstLaunch] = newValue
        }
    }
    
    private var wasPushAsked: Bool {
        get {
            return Defaults[\.wasPushPermissionAsked] ?? false
        }
        
        set {
            Defaults[\.wasPushPermissionAsked] = newValue
        }
    }
    
    private var wasSignIn: Bool {
        get {
            return Defaults[\.wasSignIn] ?? false
        }
        
        set {
            Defaults[\.wasSignIn] = newValue
        }
    }
    
    private var wasRegister: Bool {
        get {
            return Defaults[\.wasRegister] ?? false
        }
        
        set {
            Defaults[\.wasRegister] = newValue
        }
    }
}

extension DefaultsKeys {
    
    private enum keys: String {
        case isUserInApp
        case wasPushPermissionAsked
        case wasSignIn
        case wasRegister
        case isGuest
    }
    
    var isItTheFirstLaunch: DefaultsKey<Bool?> {.init(keys.isUserInApp.rawValue)}
    var wasPushPermissionAsked: DefaultsKey<Bool?> {.init(keys.wasPushPermissionAsked.rawValue)}
    var wasSignIn: DefaultsKey<Bool?> {.init(keys.wasSignIn.rawValue)}
    var wasRegister: DefaultsKey<Bool?> {.init(keys.wasRegister.rawValue)}
    var isGuest: DefaultsKey<Bool?> {.init(keys.wasRegister.rawValue)}
}
