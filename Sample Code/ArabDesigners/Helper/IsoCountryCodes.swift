//
//  IsoCountryCodes.swift
//  IsoCountryCodes
//
 
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 09/01/15.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

class IsoCountryCodes {

    class func find(key: String) -> IsoCountryInfo? {
        let countries = IsoCountries.allCountries.filter({ $0.alpha2 == key.uppercased() ||
            $0.alpha3 == key.uppercased() || $0.numeric == key })
        return countries.first
    }

    class func searchByName(_ name: String) -> IsoCountryInfo? {
        let options: String.CompareOptions = [.diacriticInsensitive, .caseInsensitive]
        let name = name.folding(options: options, locale: .current)
        let countries = IsoCountries.allCountries.filter({
            $0.name.folding(options: options, locale: .current) == name
        })
        // If we cannot find a full name match, try a partial match
        return countries.count == 1 ? countries.first : searchByPartialName(name)
    }

    private class func searchByPartialName(_ name: String) -> IsoCountryInfo? {
        guard name.count > 3 else {
            return nil
        }
        let options: String.CompareOptions = [.diacriticInsensitive, .caseInsensitive]
        let name = name.folding(options: options, locale: .current)
        let countries = IsoCountries.allCountries.filter({
            $0.name.folding(options: options, locale: .current).contains(name)
        })
        // It is possible that the results are ambiguous, in that case return nothing
        // (e.g., there are two Koreas and two Congos)
        guard countries.count == 1 else {
            return nil
        }
        return countries.first
    }

    class func searchByNumeric(_ numeric: String) -> IsoCountryInfo? {
        let countries = IsoCountries.allCountries.filter({ $0.numeric == numeric })
        return countries.first
    }

    class func searchByCurrency(_ currency: String) -> [IsoCountryInfo] {
        let countries = IsoCountries.allCountries.filter({ $0.currency == currency })
        return countries
    }

    class func searchByCallingCode(_ calllingCode: String) -> [IsoCountryInfo] {
        let countries = IsoCountries.allCountries.filter({ $0.calling == calllingCode })
        return countries
    }
}
