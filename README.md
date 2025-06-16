Nephro_doppler_IQ
This project was developed during my internship with REGIM Lab at ENIS, with the aim of assisting doctors at Hedi Chaker Hospital, Sfax, specializing in nephro_doppler. The project consists of both a mobile and web application built using Flutter and Firebase, along with an AI model to evaluate and classify patient data.

Project Overview
The Nephro_doppler_IQ application helps doctors digitize and save photos and videos of patients directly to Google Drive. Additionally, an AI model is integrated to assess the quality of the input data and classify it accurately.

Features
Digitization: Seamlessly save patient photos and videos to Google Drive for better data management and accessibility.
AI Evaluation: Utilize an AI model to assess the quality of input data, ensuring high standards.
Data Classification: Automatically classify the input data to streamline the workflow for medical professionals.
Cross-Platform Support: Available as both a mobile application and a web application, providing flexibility and accessibility.
Technologies Used
Flutter: For building both the mobile and web applications.
Firebase: For backend services, including authentication, Firestore database, and storage.
Google Drive API: For storing patient photos and videos.
AI Model: For evaluating and classifying input data.
Installation
To run this project locally, follow these steps:

Clone the repository:



git clone https://github.com/med-adam-alimi/Nephro_doppler_IQ.git
Navigate to the project directory:


Copier:
cd Nephro_doppler_IQ
Install dependencies:

copier:
flutter pub get
Configure Firebase:

Set up a Firebase project in the Firebase Console.
Add your google-services.json (for Android) and GoogleService-Info.plist (for iOS) files to the respective directories.
For web, update the Firebase configuration in web/index.html.
Run the application:


Copie:
flutter run
Usage
Doctors: Use the application to capture and upload patient photos and videos to Google Drive.
Admins: Review and manage the digitized data, and ensure the quality of the input data using the AI model.
Contributing
Contributions are welcome! If you have any suggestions or improvements, please create an issue or submit a pull request.

License
This project is licensed under the MIT License. See the LICENSE file for more details.

Acknowledgments
Special thanks to REGIM Lab and ENIS for providing the opportunity and support to work on this project.

Gratitude to the doctors at Hedi Chaker Hospital for their collaboration and feedback.
Contact
For any inquiries or questions, feel free to reach out to me on LinkedIn.
