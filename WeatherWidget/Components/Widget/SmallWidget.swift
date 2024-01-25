//
//  SmallWidget.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 11/01/24.
//

import SwiftUI
import Photos

struct SmallWidgetView: View {
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
                    VStack (spacing: 8) {
                        Image(uiImage: weatherImage ?? UIImage(named: "SunBehindCloud") ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.height / 2, height: geometry.size.height / 2)
                            .padding(8)
                        Text(weatherConfig.name)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .foregroundColor(backgroundPhoto != nil ? Color.white : Color.black)
                        
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .alignmentGuide(HorizontalAlignment.center) { dimensions in
                        return dimensions[HorizontalAlignment.center]
                    }
                }
            }
        }
    }
}
