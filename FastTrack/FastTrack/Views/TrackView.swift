//
//  TrackView.swift
//  FastTrack
//
//  Created by Jake Quinter on 1/5/23.
//

import SwiftUI

struct TrackView: View {
    let track: Track
    let onSelected: (Track) -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        Button {
            onSelected(track)
        } label: {
            ZStack(alignment: .bottom) {
                AsyncImage(url: track.artworkURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    case .failure(_):
                        Image(systemName: "questionmark")
                            .symbolVariant(.circle)
                            .font(.largeTitle)
                    default:
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                .scaleEffect(isHovering ?  1.2 : 1.0)
                
                VStack {
                    Text(track.trackName)
                        .font(.headline)
                        .lineLimit(2)
                    Text(track.artistName)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .padding(5)
                .frame(width: 150)
                .background(.regularMaterial)
            }
        }
        .buttonStyle(.borderless)
        .onHover { hovering in
            withAnimation {
                isHovering = hovering
            }
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(track: Track(trackId: 1, artistName: "Jake Quinter", trackName: "Testing song", previewUrl: URL(string: "url")!, artworkUrl100: "https://localhost:3000")) { track in
            
        }
    }
}
