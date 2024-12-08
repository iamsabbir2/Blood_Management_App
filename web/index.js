// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-app.js";
import { getMessaging, onMessage } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging.js";

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

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const messaging = getMessaging(app);

// Handle foreground messages
onMessage(messaging, (payload) => {
    console.log('Message received. ', payload);
    // Customize notification here
    const notificationTitle = payload.notification?.title || 'Foreground Message Title';
    const notificationOptions = {
        body: payload.notification?.body || 'Foreground Message body.',
        icon: payload.notification?.icon || '/firebase-logo.png',
    };

    new Notification(notificationTitle, notificationOptions);
});

// Register service worker
if ('serviceWorker' in navigator) {
    console.log('Service worker supported!');
    navigator.serviceWorker.register('firebase-messaging-sw.js').then((registration) => {
        console.log('Service Worker Registered');
    }).catch((err) => {
        console.log('Service Worker registration failed:', err);
    });
}