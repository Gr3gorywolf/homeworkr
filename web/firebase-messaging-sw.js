importScripts('https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js');
firebase.initializeApp({
    apiKey: "AIzaSyA0kSUImhyKfXftX6SMM1Y_J4jzwfp2gNo",
    authDomain: "homeworkr.firebaseapp.com",
    projectId: "homeworkr",
    storageBucket: "homeworkr.appspot.com",
    messagingSenderId: "502912002877",
    appId: "1:502912002877:web:aa7a3570c11c5e0254b354",
    measurementId: "G-QBNREJEHBR"
  });
const messaging = firebase.messaging();