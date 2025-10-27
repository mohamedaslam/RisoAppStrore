//
//  KeychainManager.swift
//  BFA
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import KeychainSwift

final class KeychainManager {
    private let keychain: KeychainSwift
    
    init(keychain: KeychainSwift = .init()) {
        self.keychain = keychain
    }
    
    @discardableResult
    func set(_ value: String?, for key: String) -> Bool{
        guard let value = value else { keychain.delete(key); return false }
        return keychain.set(value, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Bool, for key: String) -> Bool {
        return keychain.set(value, forKey: key)
    }
    
    func string(for key: String) -> String? {
        return keychain.get(key)
    }
    
    func bool(for key: String) -> Bool? {
        return keychain.getBool(key)
    }
    
    @discardableResult
    func delete(for key: String) -> Bool {
        return keychain.delete(key)
    }
    
    @discardableResult
    func reset() -> Bool {
        return keychain.clear()
    }
}
