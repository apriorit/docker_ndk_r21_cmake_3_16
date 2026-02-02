// Frida Inject Script for Frida 16.9
// This script demonstrates hooking an Android app with a Toast message
// using the callback-based Java.scheduleOnMainThread() API

Java.perform(function () {
    var context = Java.use('android.app.ActivityThread').currentApplication().getApplicationContext();
    Java.scheduleOnMainThread(function() {
        var Toast = Java.use("android.widget.Toast");
        var textStr = Java.use("java.lang.String").$new("THIS APP IS HOOKED => RUNTIME MALWARE DEMO WAS INJECTED");
        for (let step = 0; step < 6; step++) {
            Toast.makeText(context, textStr, 1).show();
        }
    });
});
