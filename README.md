# README.md

# WeatherWidget

This app has functionality to show weather widget that configured by user. In this app user can set the widget in iOS device based on small, medium, or large widget size. User also can choose the background for weather widget to make it more beautiful widget.

This app use API from [https://openweathermap.org/api](https://openweathermap.org/api) 

# Demo

[Weather App Demo](https://drive.google.com/file/d/1C-WbUt97ZyuFaWMttvohuVmWQyc-eZGu/view?usp=sharing)

# Project Structure

```
WeatherWidget
|- Components
|- Constants
|- Extensions
|- Models
|- Network
|- Screens
|- Services
|- Utils
```

| Folder Name | Description |
| --- | --- |
| Components | In this folder contains all the components that used in this app. From widget view until collection view cell. |
| Constants | In this folder contains all the constants. |
| Extensions | In this project, I use extension codes from Apple components library to make it tidy like for UIColor, FileManager, and Double |
| Models | Contains all struct of models that used in entire app. |
| Network | In this folder contains all code related for the network logic to request data to API. |
| Screens | All of screens codes contain in this folder. All screen use MVVM architecture to differentiate [M]model/entity that are used in view logics and business logics, [V]view logics, and [VM]business logics |
| Services | In this folder contains all service codes that utilize network from codes inside Network folder path |
| Utils | In this folder contains all utils/helper that needed to make app working |

# Project Set Up

- clone this repository
- open this project in Xcode
- login to [https://openweathermap.org/api](https://openweathermap.org/api) to get API key
- change `APP_ID_VALUE` constant with your API key
- Choose your preferred simulator or your device
- Run the app in Xcode
