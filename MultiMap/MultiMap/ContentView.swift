//
//  ContentView.swift
//  MultiMap
//
//  Created by Jake Quinter on 12/29/22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @AppStorage("searchText") private var searchText = ""
    
    @State private var selectedLocations = Set<Location>()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.361145, longitude: -71.057083), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var locations = [Location]()
    
    var body: some View {
        NavigationSplitView {
            List(locations, selection: $selectedLocations) { location in
                Text(location.name)
                    .tag(location)
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            delete(location)
                        }
                    }
            }
            .frame(width: 200)
        } detail: {
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Text(location.name)
                        .font(.headline)
                        .padding(5)
                        .padding(.horizontal, 4)
                        .background(.black)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .onChange(of: selectedLocations) { _ in
            var visibleMap = MKMapRect.null
            
            for location in selectedLocations {
                let mapPoint = MKMapPoint(location.coordinate)
                let pointRect = MKMapRect(x: mapPoint.x - 100000, y: mapPoint.y - 100000, width: 200000, height: 200000)
                visibleMap = visibleMap.union(pointRect)
            }
            
            var newRegion = MKCoordinateRegion(visibleMap)
            newRegion.span.latitudeDelta *= 1.5
            newRegion.span.longitudeDelta *= 1.5
            
            withAnimation {
                region = newRegion
            }
        }
        .onDeleteCommand {
            for location in selectedLocations {
                delete(location)
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search, search)
    }
    
    func search() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else { return }
            guard let item = response.mapItems.first else { return }
            guard let itemName = item.name, let itemLocation = item.placemark.location else { return }
            
            let newLocation = Location(name: itemName, latitude: itemLocation.coordinate.latitude, longitude: itemLocation.coordinate.longitude)
            locations.append(newLocation)
            selectedLocations = [newLocation]
            searchText = ""
        }
    }
    
    func delete(_ location: Location) {
        guard let index = locations.firstIndex(of: location) else { return }
        locations.remove(at: index)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
