//
//  AddressSearchBar.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-08.
//

import SwiftUI
import MapKit

struct AddressSearchBar: View {
    
    @StateObject var locationSearchService = LocationSearchService()
    
    @State private var searchResult: MKLocalSearchCompletion?
    @State private var searchResultPlacemark: MKPlacemark?
    @State private var search: Bool = false
    @State private var showAlert: Bool = false
    @State private var previousSearches: [AddressCoordinate] = StorageManager.addressCoordinates
    
    private var searchResultString: Binding<String>
    
    private let onAddress: () -> Void
    
    init(searchResultString: Binding<String>, onAddress: @escaping () -> Void) {
        self.searchResultString = searchResultString
        self.onAddress = onAddress
    }
    
    public func reloadPreviousSearches() -> Void {
        previousSearches = StorageManager.addressCoordinates
                
        onAddress()
    }
    
    private func updatePreviousSearches(_ addressCoordinate: AddressCoordinate) -> Void {
        
        var placemarks = StorageManager.addressCoordinates
        
        if let index = placemarks.firstIndex(where: { $0 == addressCoordinate}) {
            placemarks.remove(at: index)
        }
        
        placemarks.insert(addressCoordinate, at: 0)
        
        if placemarks.count == 10 {
            placemarks.remove(at: 9)
        }
        
        StorageManager.addressCoordinates = placemarks
        
        reloadPreviousSearches()
    }
    
    private func updatePreviousSearches(_ placemark: MKPlacemark) -> Void {
        updatePreviousSearches(AddressCoordinate.from(placemark: placemark))
    }
    
    private func setSearchResultString(_ result: MKLocalSearchCompletion?) -> Void {
        if let result = result {
            searchResult = result
            MKLocalSearch(request: .init(completion: result))
                .start { handler, error in
                    if let handler = handler, let mapItem = handler.mapItems.first {
                        searchResultPlacemark = mapItem.placemark
                        searchResultString.wrappedValue = mapItem.placemark.readableAddress()
                        updatePreviousSearches(mapItem.placemark)
                        search = false
                    } else {
                        searchResult = nil
                        searchResultPlacemark = nil
                        searchResultString.wrappedValue = ""
                        showAlert = true
                    }
                }
        } else {
            showAlert = true
        }
        /*
         if let location = searchResultPlacemark {
         //vm.loadPosts(location: location)
         onAddress()
         }
         */
    }
    
    var body: some View {
        Button(action: {
            search = true
            locationSearchService.searchQuery = ""
        }, label: {
            SearchBar(text: searchResultString, enabled: .constant(false))
                .padding(.vertical, -10)
                .padding(.horizontal, -8)
        })
        .sheet(isPresented: $search) {
            VStack {
                HStack {
                    SearchBar(text: $locationSearchService.searchQuery, startWithFocus: true) {
                        // Takes the top most result if the user clicks the search key
                        if let topResult = locationSearchService.completions.first {
                            setSearchResultString(topResult)
                        }
                    }
                    
                    Button(action: {
                        search = false
                    }, label: {
                        Text("cancel-FC")
                    })
                }
                
                if locationSearchService.searchQuery.isEmpty {
                    List {
                        Text("previous_addresses-FC")
                            .font(.footnote)
                        
                        ForEach(previousSearches, id: \.self) { addressCoordinate in
                            Button(action: {
                                updatePreviousSearches(addressCoordinate)
                                searchResultString.wrappedValue = addressCoordinate.readableAddress
                                search = false
                            }, label: {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    Text(addressCoordinate.readableAddress)
                                }
                            })
                        }
                    }
                } else {
                    List(locationSearchService.completions) { result in
                        Button(action: {
                            setSearchResultString(result)
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(result.title)
                                Text(result.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        })
                    }
                }
            }
            .padding(8)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("error-FC"),
                      message: Text("failed_to_retrieve_the_address-FC-s"),
                      dismissButton: .default(Text("close-FC")))
            })
        }
        .onAppear {
            reloadPreviousSearches()
        }
    }
}

struct AddressSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        AddressSearchBar (searchResultString: .constant("")) {
            
        }
    }
}
