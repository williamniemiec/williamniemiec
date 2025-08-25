// Firebase configuration for web
const firebaseConfig = {
  apiKey: "demo-api-key",
  authDomain: "teams-app-demo.firebaseapp.com",
  projectId: "teams-app-demo",
  storageBucket: "teams-app-demo.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef123456"
};

// Initialize Firebase
import { initializeApp } from 'firebase/app';
const app = initializeApp(firebaseConfig);