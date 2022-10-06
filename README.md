# Assessment

Creative Advance Assessment
 
# Version

Flutter 3.3.3 • channel stable
Dart 2.18.2 • DevTools 2.15.0


## Getting Started

This project consists of mainly 4 screens:

Splash Screen

Event List Screen (Dashboard)

Favorite List Screen (Dashboard)

Event Details Screen

# How to clone Project:
 To Clone Bundle follow steps shown below
- paste assessment bundle in one folder
- open terminal on that folder
- Run command  "git clone assessment.bundle"

# Steps before Running:
For Iphone please run below

- To run the code on IOS please set minimum deployment target to 14 onXcode as well.
- add these lines on terminal
- 
cd ios && arch -x86_64 pod install && cd ../  (For M1 Chip)

OR

cd ios &&  pod install && cd ../  (For Intel Chip)

# About the project

1: For state-management use Provider (Recommended By Flutter)

2: To fetch data from Api calls uses Dio package

3: Use Hive package to store favorite data locally

4: For API call its using dio:
        api_functions.dart file has all the API call methods, and also before calling an API checking network availability.

5: For font using loto family

6: Most reusable UI(s) are created as separate components which can be found in ui/global_widget folders.

# Screen recording of the flow 

        https://drive.google.com/file/d/14dkWvCSCS-I6aP-8O0OYS6UZSGKz282a/view?usp=sharing








