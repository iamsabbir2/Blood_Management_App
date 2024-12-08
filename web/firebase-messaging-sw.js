importScripts('firebase-app.js');
importScripts('firebase-messaging.js');

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyCIVvpqw8lAMDmjVjviTVO4uCa62BGvsJo",
    authDomain: "bloodmanagementapp-b2314.firebaseapp.com",
    projectId: "bloodmanagementapp-b2314",
    storageBucket: "bloodmanagementapp-b2314.appspot.com",
    messagingSenderId: "454925533198",
    appId: "1:454925533198:web:282d542b14390a7bacbc5f",
    measurementId: "G-6F9W4JT4ZW"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
    console.log('Received background message ', payload);

    // Customize notification here
    const notificationTitle = payload.notification?.title || 'Background Message Title';
    const notificationOptions = {
        body: payload.notification?.body || 'Background Message body.',
        icon: payload.notification?.icon || '/firebase-logo.png',
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});