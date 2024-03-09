//
//  GetLastDayOfLastMonth.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-03.
//

import Foundation

public func getLastDayOfLastMonth() -> Int {
    let calender = Calendar.current
    let numberOfDays = calender.range(
        of: .day,
        in: .month,
        for: calender.date(
            byAdding: .month,
            value: -1,
            to: Date())!
    )!.count
    
    return numberOfDays
}
