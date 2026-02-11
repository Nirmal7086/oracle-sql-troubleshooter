# MinimalTodo - iOS Todo App

A clean, minimalist personal todo list app built with SwiftUI.

## Features

- Add, complete, and delete todos
- Swipe to delete
- Clear all completed items at once
- Data persists locally using UserDefaults
- Dark mode support
- Portrait-optimized layout

## Requirements

- macOS 13+ with **Xcode 15+**
- iOS 17.0+ target device or simulator
- Apple Developer account (free tier works for personal device installs)

## Project Structure

```
MinimalTodo/
├── MinimalTodo.xcodeproj/      # Xcode project file
├── MinimalTodo/
│   ├── MinimalTodoApp.swift    # App entry point
│   ├── Models/
│   │   └── TodoItem.swift      # Todo data model
│   ├── ViewModels/
│   │   └── TodoStore.swift     # State management & persistence
│   ├── Views/
│   │   ├── TodoListView.swift  # Main list screen
│   │   └── TodoRowView.swift   # Individual todo row
│   ├── Assets.xcassets/        # App icons & colors
│   └── Info.plist              # App configuration
├── ExportOptions-dev.plist     # IPA export config
├── build.sh                    # Build & export script
├── INSTALL.md                  # Local installation guide
└── README.md                   # This file
```

## Quick Start

### Option 1: Open in Xcode (Recommended)

1. Clone this repository
2. Open `MinimalTodo/MinimalTodo.xcodeproj` in Xcode
3. Select your device or simulator from the toolbar
4. Press **Cmd + R** to build and run

### Option 2: Build Script

```bash
cd MinimalTodo
chmod +x build.sh
./build.sh          # Debug build
./build.sh release  # Release build
```

The IPA will be at `build/export/MinimalTodo.ipa`.

## Install on Your iPhone (Without App Store)

See **[INSTALL.md](INSTALL.md)** for detailed instructions on installing the app directly on your device using your free Apple Developer account.

---

## App Store Deployment Guide

### Prerequisites

1. **Apple Developer Program membership** ($99/year) at [developer.apple.com](https://developer.apple.com/programs/)
2. **Xcode 15+** installed from the Mac App Store
3. **App Store Connect** account linked to your developer membership

### Step 1: Configure Signing

1. Open `MinimalTodo.xcodeproj` in Xcode
2. Select the **MinimalTodo** target > **Signing & Capabilities**
3. Check **Automatically manage signing**
4. Select your **Team** (your paid developer account)
5. Update the **Bundle Identifier** to something unique:
   - Example: `com.yourname.MinimalTodo`

### Step 2: Create App Store Connect Listing

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Click **My Apps** > **+** > **New App**
3. Fill in:
   - **Platform:** iOS
   - **Name:** MinimalTodo (or your preferred name)
   - **Primary Language:** English
   - **Bundle ID:** Select the one from Xcode
   - **SKU:** `minimaltodo-001`
4. Click **Create**

### Step 3: Prepare App Metadata

In App Store Connect, fill out:

- **Description:** A clean, minimalist todo list for staying organized.
- **Keywords:** todo, tasks, minimal, checklist, organizer
- **Support URL:** Your website or GitHub repo URL
- **Screenshots:** (capture from Simulator — see below)
- **App Icon:** 1024x1024 PNG (no alpha, no rounded corners)

#### Taking Screenshots

```bash
# In Xcode Simulator, use:
# Cmd + S to save a screenshot
# Required sizes:
#   - iPhone 6.7" (iPhone 15 Pro Max): 1290 x 2796
#   - iPhone 6.5" (iPhone 14 Plus):    1284 x 2778
#   - iPad 12.9":                       2048 x 2732
```

### Step 4: Archive & Upload

1. In Xcode, set the device to **Any iOS Device (arm64)**
2. Go to **Product** > **Archive**
3. Once complete, the **Organizer** window opens
4. Select the archive > **Distribute App**
5. Choose **App Store Connect** > **Upload**
6. Follow the prompts (accept defaults)
7. Wait for Apple to process (~15 minutes)

### Step 5: Submit for Review

1. Back in App Store Connect, go to your app
2. Under **Build**, click **+** and select the uploaded build
3. Fill in:
   - **Version Release:** Manual or Automatic
   - **App Review Information:** Contact details
   - **Content Rights:** Confirm you own all content
4. Click **Submit for Review**

### Step 6: Wait for Approval

- **Typical review time:** 24-48 hours
- You'll receive an email when approved (or if changes are needed)
- Once approved and released, the app appears on the App Store

### Common Rejection Reasons & Fixes

| Reason | Fix |
|--------|-----|
| Crashes on launch | Test on real device before submitting |
| Incomplete metadata | Fill all required fields in App Store Connect |
| Missing privacy policy | Add a privacy policy URL (even a simple GitHub page) |
| Placeholder content | Remove any "Lorem ipsum" or test data |
| Broken links | Verify support URL works |

### Privacy Policy

Since this app stores data only locally (no network, no analytics), a simple privacy policy works:

> **MinimalTodo Privacy Policy**
> This app does not collect, store, or transmit any personal data. All todo items are stored locally on your device and are never shared with any third party.

Host this on a GitHub Gist or your personal website and link it in App Store Connect.

---

## Updating the App

1. Increment version in `Info.plist`:
   - `CFBundleShortVersionString` → e.g., `1.1.0`
   - `CFBundleVersion` → increment build number
2. Archive and upload again
3. Create a new version in App Store Connect
4. Submit for review

## License

Personal use. Feel free to modify for your own needs.
