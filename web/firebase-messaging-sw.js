importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');


// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyBkdkjdZyEn4_d436x4Jq_G_39jVynXX1k",
    authDomain: "compass-automatic-gear.firebaseapp.com",
    projectId: "compass-automatic-gear",
    storageBucket: "compass-automatic-gear.appspot.com",
    messagingSenderId: "660504023083",
    appId: "1:660504023083:web:becd167feb642c230b9a6e",
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Retrieve Firebase Messaging
const messaging = firebase.messaging();

// Optional: Handle background messages
messaging.onBackgroundMessage(function (payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    // Customize notification here
    const notificationTitle = payload.notification.title || "Notification Title";
    const notificationOptions = {
        body: payload.notification.body || "Notification Body",
        icon: '/firebase-logo.png', // Replace with your app icon
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});