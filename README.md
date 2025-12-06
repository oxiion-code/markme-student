# Student App - README

## 📱 Overview

The **Student App** is part of the **Attendance System** designed for colleges. It enables students to register, view live classes, and mark their attendance using **Bluetooth proximity** and **fingerprint authentication**.

This app communicates with the Admin and Teacher modules to ensure secure and automated attendance tracking.

---

## 🚀 Features

### 🔐 **Authentication & Registration**

* Register using **College Registration ID**
* Select **College**, **Branch**, and complete profile setup
* Secure login flow

### 📚 **Live Classes**

* View currently active classes started by the teacher
* Class details: subject, branch, year, teacher name, and timings

### 🧭 **Attendance Marking**

* Detect the **Teacher's Bluetooth MAC address** automatically
* Must remain within Bluetooth proximity range
* Confirm identity using **fingerprint biometrics**
* Single-tap attendance marking

### 📊 **Attendance Records**

* View personal attendance history
* Track day-wise and subject-wise attendance

---

## 🛠️ Tech Stack

* **Flutter** (Frontend)
* **BLoC** for State Management
* **GetIt** for Dependency Injection
* **GoRouter** for Navigation
* **Native Android APIs** for Bluetooth scanning
* **Local Storage:** Hive / Shared Preferences (depending on configuration)
* **Backend:** To be integrated (Firebase / Custom API)

---

## 📂 Folder Structure

```
lib/
  bloc/                    # State management
  models/                  # Data models (Student, Class, Attendance)
  repositories/            # API & Local DB handling
  screens/                 # UI Screens
  services/                # Bluetooth, biometrics, auth services
  widgets/                 # Reusable widgets
  main.dart                # App entry point
```

---

## 🔧 Core Functionalities Explained

### 1️⃣ **Bluetooth-Based Detection**

* Scans for teacher devices broadcasting their **MAC address**


### 4️⃣ **Offline Support**

* Attendance is cached if network fails
* Auto-sync when online

---

## 🖼️ UI Flow

1. **Splash Screen**
2. **Login/Register**
3. **Home Screen** → Live Classes Card
4. **Class Details**
5. **Attendance Confirmation**
6. **Success Page**

---

## 📦 Installation

### Prerequisites

* Flutter SDK 3.10+
* Android Studio / VS Code
* Android device with **Bluetooth** and **Fingerprint** sensor

### Steps

```bash
git clone <repo-url>
cd student_app
flutter pub get
flutter run
```
## 🧪 Testing Checklist

* [ ] Bluetooth scanning works
* [ ] Teacher MAC detection
* [ ] Fingerprint prompt displayed
* [ ] Fake GPS / spoofing prevention
* [ ] Attendance submitted
* [ ] Attendance visible in history

---

## 📌 Roadmap

* Add push notifications
* Implement offline-first synchronization fully
* Add profile editing
* Add timetable integration

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first.

---

## 📝 License

This project is licensed under the **MIT License**.

---

## 👨‍💻 Developed By

**Rudra Narayan Rath**
