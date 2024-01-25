//
//  LargeWidget.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 11/01/24.
//

import SwiftUI

struct LargeWidgetView: View {
    var weatherConfig: WeatherResponse
    var weatherImage: UIImage?
    var backgroundPhoto: UIImage?
    @State var isLoading: Bool = false
    
    init (weatherConfig: WeatherResponse, weatherImage: UIImage?, backgroundPhoto: UIImage?) {
        self.weatherConfig = weatherConfig
        self.weatherImage = weatherImage
        self.backgroundPhoto = backgroundPhoto
    }
    
    var body: some View {
        ZStack {
            Color.clear.overlay (
                Image(uiImage: backgroundPhoto ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
                .clipped()
                .cornerRadius(16)
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2.0)
            } else {
                GeometryReader { geometry in
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(uiImage: weatherImage ?? UIImage(named: "SunBehindCloud") ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.height / 3, height: geometry.size.height / 3)
                                    .padding(.bottom, 8)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 8) {
                                    Text("lat \(weatherConfig.coord.lat.rounded(toDecimalPlaces: 2))\u{00B0}")
                                        .font(.system(size: 14))
                                        .fontWeight(.bold)
                                        .foregroundColor(backgroundPhoto != nil ? Color.white : Color.black)
                                    Text("long \(weatherConfig.coord.lon.rounded(toDecimalPlaces: 2))\u{00B0}")
                                        .font(.system(size: 14))
                                        .fontWeight(.bold)
                                        .foregroundColor(backgroundPhoto != nil ? Color.white : Color.black)
                                    Spacer()
                                }
                            }
                            .padding(.top, 8)
                            
                            Spacer()
                            Text(weatherConfig.weather.first?.description ?? "")
                                .font(.system(size: 14))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(backgroundPhoto != nil ? Color.white : Color.black)
                            Text(weatherConfig.name)
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(backgroundPhoto != nil ? Color.white : Color.black)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}
