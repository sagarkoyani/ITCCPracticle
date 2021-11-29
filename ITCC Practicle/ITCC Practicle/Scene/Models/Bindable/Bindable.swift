//
//  Bindable.swift
//  ITCC Practicle
//
//  Created by MAC on 25/11/21.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    private lazy var observer: ((T?) -> ())? = nil
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
