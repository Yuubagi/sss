#import <Foundation/Foundation.h>
#import <rootless.h>

// MobileGestaltの関数宣言
extern "C" CFPropertyListRef MGCopyAnswer(CFStringRef property);

// 変数の宣言
static NSDictionary *modifiedKeys;
static NSArray *appsChosen;

// 設定を読み込む関数
static void loadPrefs() {
    // Rootless対応のパス解決
    NSString *prefsPath = ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.tonyk7.MGSpoofHelperPrefsSuite.plist");
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:prefsPath];
    
    modifiedKeys = [prefs objectForKey:@"modifiedKeys"];
    appsChosen = [prefs objectForKey:@"appsChosen"];
}

// 通信を受け取った時の更新処理
static void appsChosenUpdated(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPrefs();
}

// フック処理
%hookf(CFPropertyListRef, MGCopyAnswer, CFStringRef property) {
    // 設定をロード
    if (!modifiedKeys) {
        loadPrefs();
    }

    NSString *key = (__bridge NSString *)property;
    
    // 特定のアプリでのみ動作させるチェック（オリジナルの仕様を継承）
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    if (appsChosen && ![appsChosen containsObject:bundleIdentifier]) {
        return %orig;
    }

    // 偽装データがあるか確認
    if (modifiedKeys && modifiedKeys[key]) {
        // 設定されている値を返す
        id val = modifiedKeys[key];
        return (__bridge_retained CFPropertyListRef)val;
    }

    return %orig;
}

// 初期化
%ctor {
    @autoreleasepool {
        loadPrefs();
        
        // 通知の登録
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            (CFNotificationCallback)appsChosenUpdated,
            CFSTR("com.tonyk7.mgspoof/appsChosenUpdated"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );
        
        %init;
    }
}