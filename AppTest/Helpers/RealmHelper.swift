//
//  RealmHelper.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Realm
import RealmSwift
import Unrealm
typealias UResults = Unrealm.Results
final class RealmHelper {
    
    static var realm: Realm? {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch {
                print("ERROR: (REALM) Unable to access realm db => \(error)")
            }
            return nil
        }
    }

    
    func objects<T: Realmable>(_ type: T.Type, predicate: NSPredicate? = nil) -> UResults<T>? {
        if !isRealmAccessible() { return nil }
        RealmHelper.realm?.refresh()
        if let searchPredicate = predicate {
            return RealmHelper.realm?.objects(type).filter(searchPredicate)
        }
        return RealmHelper.realm?.objects(type)
    }

    func object<T: Realmable>(_ type: T.Type, key: String) -> T? {
        if !isRealmAccessible() { return nil }

        let realm = RealmHelper.realm
        realm?.refresh()

        return realm?.object(ofType: type, forPrimaryKey: key)
    }

    func add<T: Realmable>(_ data: [T], update: Bool = true) {
        if !isRealmAccessible() { return }

        let realm = RealmHelper.realm
        realm?.refresh()

        if realm?.isInWriteTransaction == true {
            realm?.add(data, update: update)
        } else {
            try? realm?.write {
                realm?.add(data, update: update)
            }
        }
    }

    func add<T: Realmable>(_ data: T, update: Bool = true) {
        add([data], update: update)
    }

    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }

        let realm = RealmHelper.realm
        realm?.refresh()

        try? realm?.write {
            action()
        }
    }

    func delete<T: Realmable>(_ data: [T]) {
        let realm = RealmHelper.realm
        realm?.refresh()
        try? realm?.write { realm?.delete(data) }
    }

    func delete<T: Realmable>(_ data: T) {
        delete([data])
    }

    func clearAllData() {
        if !isRealmAccessible() { return }

        let realm = RealmHelper.realm
        realm?.refresh()
        try? realm?.write { realm?.deleteAll() }
    }
}

extension RealmHelper {
    func isRealmAccessible() -> Bool {
        do { _ = try Realm() } catch {
            print("Realm is not accessible ---> \(error)")
            return false
        }
        return true
    }

    func configureRealm() {
        let config = RLMRealmConfiguration.default()
        config.deleteRealmIfMigrationNeeded = true
        RLMRealmConfiguration.setDefault(config)
    }
}
