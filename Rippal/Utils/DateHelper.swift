//
//  DateHelper.swift
//  Rippal
//
//  Created by Tao Wang on 1/30/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation

// TODO: use localized strings for this too
let daysOfWeek: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
let months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

final class DateHelper {
    
    static let sharedInstance = DateHelper()
    let cal = Calendar.current
    private init() {}
    
    func constructExploreDateString(date: Date) -> String {
        let dayOfWeek = cal.component(.weekday, from: date) - 1
        let month = cal.component(.month, from: date) - 1
        return getDayOfWeekInText(day: dayOfWeek) + " - " + getMonthsInText(month: month) + " " + String(cal.component(.day, from: date)) + " " + String(cal.component(.year, from: date));
    }
    
    private func getDayOfWeekInText(day: Int) -> String {
        return daysOfWeek[day % 7]
    }
    
    private func getMonthsInText(month: Int) -> String {
        return months[month]
    }
}

