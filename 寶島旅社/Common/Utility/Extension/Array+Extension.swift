//
//  Array+Extension.swift
//  寶島旅社
//
//  Created by Eric Lin on 2023/1/11.
//  Copyright © 2023 Eric Lin. All rights reserved.
//

extension Array where Element: Identifiable {
    func indexOfElement(with id: Element.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}
