//
//  SwiftUtilities.swift
//
//  Created by Sylvain on 17/Mar/2015.
//  Updated 4/Jan/2016
//

import Foundation


/**  
 Rounds the number to the nearest significant digit specified. eg (3.14159..., 3) -> 3.14
 - seealso: [source stackoverflow](http://stackoverflow.com/questions/202302/rounding-to-an-arbitrary-number-of-significant-digits)
*/
public func roundToSignificantFigures(number: Double, sigFigs: UInt = 2) -> Double {
    precondition(number.isNormal, "roundToSignificantFigures - Number must be Normal")
    
    guard sigFigs > 0 else {
        return 0.0
    }
    
    let d: Double = ceil(log10(number < 0 ? -number : number))
    let power = Double(sigFigs) - d
    
    let magnitude: Double = pow(10, power)
    let shifted: Double = round(number * magnitude)
    return shifted/magnitude;
}

enum TimerError: ErrorType {
    case machTimeBaseInfoFailure
}

/// performance testing
public func Timer(count: UInt, block: () -> Void) throws -> (averageTime: Double, bestTime: Double) {
    
    guard count > 0 else {
        return (0, 0)
    }
    
    var info: mach_timebase_info = mach_timebase_info(numer: 0, denom: 0)
    guard mach_timebase_info(&info) == KERN_SUCCESS else {
        throw TimerError.machTimeBaseInfoFailure
    }
    
    var best, average: UInt64
    best = UInt64(1e20)
    average = 0
    
    for _ in 0..<count {
        let start = mach_absolute_time()
        
        block()
    
        let elapsed = mach_absolute_time() - start
        if elapsed < best { best = elapsed }
        average += elapsed
    }
    
    let numer: Double = Double(info.numer) / Double(info.denom) / Double(NSEC_PER_SEC)
    let averageTime = (Double(average) / Double(count)) * numer
    let bestTime = Double(best) * numer
    
    return (averageTime, bestTime)
}

/// testing optionals for a valid value without regard to what the value is
public func hasValue<T>(value: T?) -> Bool {
    switch value {
    case .Some(_): return true
    case .None: return false
    }
}


