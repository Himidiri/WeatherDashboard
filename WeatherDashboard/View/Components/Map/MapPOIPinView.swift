//
//  MapPOIPinView.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct MapPOIPinView: View {
    var body: some View {
        Image(systemName: "mappin.circle.fill")
            .font(.title)
            .foregroundStyle(.red)
            .shadow(radius: 2)
    }
}

#Preview {
    MapPOIPinView()
}
