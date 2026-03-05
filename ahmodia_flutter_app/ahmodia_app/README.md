# 🍛 Ahmodia Restaurant — Flutter Android App

A complete food ordering Android app built with Flutter + Firebase.

---

## 📁 Project Structure

```
ahmodia_app/
├── lib/
│   ├── main.dart              ← App entry + Splash screen
│   ├── theme/
│   │   └── app_theme.dart     ← Colors, fonts, theme
│   ├── models/
│   │   └── models.dart        ← MenuItem, CartItem, Order, User models + AppData
│   ├── providers/
│   │   └── cart_provider.dart ← Cart state management
│   ├── services/
│   │   └── firebase_service.dart ← Firebase Auth + Firestore
│   ├── widgets/
│   │   └── widgets.dart       ← Reusable UI components
│   └── screens/
│       └── screens.dart       ← All screens (Home, Cart, Track, Profile, Payment)
├── pubspec.yaml               ← Dependencies
└── README.md
```

---

## ⚙️ Setup Steps

### Step 1 — Install Flutter
```bash
# Download Flutter SDK from flutter.dev
# Add flutter to your PATH
flutter doctor  # Check everything is ready
```

### Step 2 — Install Android Studio
- Download from developer.android.com/studio
- Install Android SDK (API 34)
- Set up an Android Emulator OR connect real Android phone

### Step 3 — Clone & Install Dependencies
```bash
cd ahmodia_app
flutter pub get
```

### Step 4 — Setup Firebase
1. Go to console.firebase.google.com
2. Create project: `ahmodia-restaurant`
3. Add Android app:
   - Package name: `com.ahmodia.restaurant`
   - Download `google-services.json`
   - Place it in: `android/app/google-services.json`
4. Enable Authentication → Google Sign-In
5. Enable Firestore Database

### Step 5 — Add Firebase Config in main.dart
Replace the placeholder values in `lib/main.dart`:
```dart
const firebaseOptions = FirebaseOptions(
  apiKey:            'YOUR_ACTUAL_API_KEY',
  appId:             'YOUR_ACTUAL_APP_ID',
  messagingSenderId: 'YOUR_ACTUAL_SENDER_ID',
  projectId:         'ahmodia-restaurant',
  storageBucket:     'ahmodia-restaurant.appspot.com',
);
```

### Step 6 — Run on Emulator or Phone
```bash
flutter run                    # Debug mode (hot reload)
flutter run --release          # Release mode (faster)
```

### Step 7 — Build APK for sharing
```bash
# Debug APK (for testing, larger file)
flutter build apk --debug

# Release APK (for sharing, smaller + optimized)
flutter build apk --release

# Output location:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 App Features

| Feature | Status |
|---------|--------|
| 🍚 Rice Pack ordering (Half/Full + Add-ons) | ✅ |
| 🥘 Thali Combos & À la Carte | ✅ |
| 🛒 Cart with live total | ✅ |
| 🏠 Checkout with delivery details | ✅ |
| 💵 Cash on Delivery | ✅ |
| 📱 UPI Payment (Razorpay) | ✅ UI ready |
| 💳 Card Payment | ✅ UI ready |
| 📍 Live Order Tracking | ✅ |
| 👤 Google Sign-In | ✅ |
| 🔥 Firebase Firestore | ✅ |
| 🌿 Splash Screen | ✅ |

---

## 💳 Adding Razorpay (UPI + Card payments)

In `lib/screens/screens.dart`, in the `_placeOrder()` method, add:

```dart
// 1. Create Razorpay instance
final _razorpay = Razorpay();

// 2. Set up listeners in initState
_razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
_razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);

// 3. Open checkout
var options = {
  'key': 'rzp_live_YOUR_KEY',
  'amount': (cart.grandTotal * 100).toInt(), // paise
  'name': 'Ahmodia Restaurant',
  'description': 'Food Order $orderId',
  'prefill': {
    'name': widget.customerName,
    'contact': widget.customerPhone,
  },
  'theme': {'color': '#1B4332'},
};
_razorpay.open(options);

// 4. On success → save order to Firestore
void _onSuccess(PaymentSuccessResponse response) {
  // Save order with payment details
}
```

---

## 🔐 Firestore Security Rules

Paste in Firebase Console → Firestore → Rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isLoggedIn() { return request.auth != null; }
    function isAdmin() {
      return isLoggedIn() && exists(
        /databases/$(database)/documents/admins/$(request.auth.token.email));
    }

    match /orders/{id} {
      allow create: if isLoggedIn();
      allow read: if isAdmin() || resource.data.userId == request.auth.uid;
      allow update, delete: if isAdmin();
    }
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid || isAdmin();
    }
    match /menu/{id} {
      allow read: if true;
      allow write: if isAdmin();
    }
  }
}
```

---

## 💰 Cost Summary

| Service | Cost |
|---------|------|
| Flutter | Free |
| Firebase (Firestore + Auth) | Free (Spark plan) |
| Razorpay | 2% per online transaction |
| Play Store (optional) | $25 one-time |
| **Total fixed cost** | **₹0** |

---

## 📞 Support
Restaurant: Ahmodia Restaurant
Built with ❤️ using Flutter + Firebase
