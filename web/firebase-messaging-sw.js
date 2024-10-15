// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging.js');

firebase.initializeApp({
    apiKey: 'AIzaSyCIVvpqw8lAMDmjVjviTVO4uCa62BGvsJo',
    authDomain: 'bloodmanagementapp-b2314.firebaseapp.com',
    projectId: 'bloodmanagementapp-b2314',
    storageBucket: 'bloodmanagementapp-b2314.appspot.com',
    messagingSenderId: '454925533198',
    appId: '1:454925533198:web:282d542b14390a7bacbc5f',
    //measurementId: "YOUR_MEASUREMENT_ID"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
    console.log('Received background message ', payload);
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});