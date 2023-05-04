//
//  MKLocalSreach.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/2/23.
//

import Foundation
import MapKit

class LocalSearch : NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    let completer = MKLocalSearchCompleter()
    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
            let completer = MKLocalSearchCompleter()
            completer.delegate = self
            return completer
        }()
    @Published var searchResults = [MKLocalSearchCompletion]()
    /*override init() {
        super.init()
        completer.delegate = self
    }*/
    func search(query : String){
        localSearchCompleter.queryFragment = query
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = localSearchCompleter.results
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error in getting location")
    }
}
