
importScripts(
  'https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js'
);
importScripts(
  'https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js'
);

firebase.initializeApp({
  apiKey: 'AIzaSyCbVCos7Ap8KySYXV3NFSuOLk08guQa4Ec',
  authDomain: 'course-explorer-v2-2d335.firebaseapp.com',
  projectId: 'course-explorer-v2-2d335',
  storageBucket: 'course-explorer-v2-2d335.firebasestorage.app',
  messagingSenderId: '575603337884',
  appId: '1:575603337884:web:34f79fc72f014b9b52db59',
  measurementId: 'G-8HFLXR0DGK',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log(
    '[firebase-messaging-sw.js] Background message:',
    payload
  );
});
