# Frida Inject Scripts

This repository contains Frida inject scripts for Android applications, demonstrating compatibility across different Frida versions.

## Files

- **frida-inject-16.9.js** - Original script compatible with Frida 16.9
- **frida-inject-17.js** - Updated script compatible with Frida 17+

## What These Scripts Do

Both scripts demonstrate a runtime injection attack by:
1. Hooking into an Android application's runtime
2. Getting the application context
3. Displaying multiple Toast messages on the main thread
4. Showing "THIS APP IS HOOKED => RUNTIME MALWARE DEMO WAS INJECTED" message

## Migration from Frida 16.9 to Frida 17

### Key Changes

The main difference between the two versions is how `Java.scheduleOnMainThread()` behaves:

#### Frida 16.9 (Callback-based)
```javascript
Java.scheduleOnMainThread(function() {
    // Code runs on main thread with callback
});
```

#### Frida 17+ (Promise-based)
```javascript
Java.scheduleOnMainThread(function() {
    // Code runs on main thread
    // Function now returns a Promise
});
```

### What Changed?

In **Frida 17**, `Java.scheduleOnMainThread()` was updated to return a **Promise** instead of using the callback pattern. While the basic usage appears similar, the internal implementation now supports Promise chains.

If you need to handle the result or errors, you can use:
```javascript
Java.scheduleOnMainThread(function() {
    // Your code
}).then(function() {
    console.log("Main thread execution completed");
}).catch(function(err) {
    console.error("Error:", err);
});
```

### Backward Compatibility

The updated Frida 17 script maintains the same functional behavior as the 16.9 version while being compatible with the new Promise-based API. The script will work correctly with Frida 17+ without requiring `.then()` or `.catch()` handlers for simple use cases.

## Usage

### Prerequisites
- Android device or emulator
- Frida installed on your system
- Frida server running on the Android device
- Target Android application

### Injection Command

For **Frida 16.9**:
```bash
frida -U -f com.example.app -l frida-inject-16.9.js
```

For **Frida 17+**:
```bash
frida -U -f com.example.app -l frida-inject-17.js
```

Or attach to a running process:
```bash
frida -U com.example.app -l frida-inject-17.js
```

### Options Explained
- `-U` - Connect to USB device
- `-f` - Spawn the application
- `-l` - Load the script file
- `com.example.app` - Target application package name

## Docker Environment

This repository includes a Dockerfile that sets up an Android development environment with:
- Ubuntu 20.04
- Android NDK r21e
- Android SDK (API 29)
- Java 8 (OpenJDK)
- CMake and build tools

## Security Note

⚠️ **Warning**: These scripts are for educational and security research purposes only. Unauthorized injection into applications may violate laws and terms of service. Always obtain proper authorization before testing.

## License

Please refer to the repository license for usage terms.
