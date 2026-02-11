# Local Installation Guide - MinimalTodo

Install MinimalTodo directly on your iPhone without the App Store using your GitHub account and a free Apple Developer account.

---

## Method 1: Clone from GitHub + Xcode (Easiest)

### Prerequisites

- A Mac with **Xcode 15+** (free from Mac App Store)
- A **free Apple ID** signed into Xcode
- An iPhone with **iOS 17+**
- A USB cable to connect your iPhone to your Mac

### Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/Nirmal7086/2025.git
cd 2025/MinimalTodo
```

#### 2. Open in Xcode

```bash
open MinimalTodo.xcodeproj
```

Or: Open Xcode > File > Open > navigate to `MinimalTodo.xcodeproj`

#### 3. Set Up Signing (One-Time)

1. In Xcode, click on **MinimalTodo** in the project navigator (left sidebar)
2. Select the **MinimalTodo** target
3. Go to the **Signing & Capabilities** tab
4. Check **Automatically manage signing**
5. For **Team**, select your Apple ID
   - If you don't see your Apple ID: Go to **Xcode > Settings > Accounts > +** and sign in
6. If Xcode shows a bundle ID error, change the **Bundle Identifier** to something unique:
   - Example: `com.YOURNAME.MinimalTodo` (replace YOURNAME)

#### 4. Connect Your iPhone

1. Plug in your iPhone via USB
2. When prompted on your iPhone, tap **Trust This Computer**
3. In Xcode's toolbar, click the device selector and choose your iPhone

#### 5. Build & Run

1. Press **Cmd + R** (or click the Play button)
2. First time only: Xcode will take a moment to prepare your device
3. The app will install and launch on your iPhone

#### 6. Trust the Developer Profile (First Time Only)

If you see **"Untrusted Developer"** on your iPhone:

1. Open **Settings** on your iPhone
2. Go to **General** > **VPN & Device Management**
3. Tap your Apple ID email under **Developer App**
4. Tap **Trust** > Confirm

The app will now open normally.

### Important Notes for Free Apple ID

- Apps installed this way **expire after 7 days** — just reconnect to Xcode and press Run again to reinstall
- You can have up to **3 apps** installed this way at once
- A **paid developer account** ($99/year) removes the 7-day limit

---

## Method 2: Build Script + Manual Install

### Build the IPA

```bash
cd MinimalTodo
./build.sh
```

This creates `build/export/MinimalTodo.ipa`.

### Install via Xcode

1. Open Xcode
2. Go to **Window** > **Devices and Simulators**
3. Select your connected iPhone
4. Click **+** under **Installed Apps**
5. Select `build/export/MinimalTodo.ipa`
6. Trust the developer profile (see Step 6 above)

### Install via Finder (macOS Ventura+)

1. Connect your iPhone to your Mac
2. Open **Finder** and select your iPhone in the sidebar
3. Drag `build/export/MinimalTodo.ipa` onto the iPhone window
4. Trust the developer profile on your iPhone

### Install via Apple Configurator 2

1. Install **Apple Configurator 2** from the Mac App Store (free)
2. Connect your iPhone
3. Drag the `.ipa` file onto your device in Apple Configurator

---

## Method 3: TestFlight (For Sharing with Others)

If you have a **paid Apple Developer account** and want to share the app:

1. Archive the app in Xcode (Product > Archive)
2. Upload to App Store Connect
3. Go to [App Store Connect](https://appstoreconnect.apple.com/) > Your App > TestFlight
4. Add testers by email
5. Testers install via the **TestFlight** app on their iPhones

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Unable to install" | Check that your device is running iOS 17+ |
| "Untrusted Developer" | Settings > General > VPN & Device Management > Trust |
| Signing errors in Xcode | Change Bundle Identifier to be unique |
| "Device not available" | Update Xcode to support your iOS version |
| App disappeared after 7 days | Reconnect to Xcode and press Cmd+R to reinstall |
| "Maximum number of apps" | Delete one of your 3 free-provisioned apps first |
| Build fails | Ensure Xcode 15+ and macOS 13+ are installed |

## Quick Reference

```bash
# Clone and run in one go
git clone https://github.com/Nirmal7086/2025.git
cd 2025/MinimalTodo
open MinimalTodo.xcodeproj
# Then: Select device > Cmd+R in Xcode
```
