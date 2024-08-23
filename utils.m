#import "utils.h"

typedef struct __SecTask * SecTaskRef;
extern CFTypeRef SecTaskCopyValueForEntitlement(
        SecTaskRef task, 
        CFStringRef entitlement, 
        CFErrorRef  _Nullable *error
    ) 
    __attribute__((weak_import));

extern SecTaskRef SecTaskCreateFromSelf(CFAllocatorRef allocator)
    __attribute__((weak_import));

int getEntitlementIntValue(CFStringRef key) 
{
    if (SecTaskCreateFromSelf == NULL || SecTaskCopyValueForEntitlement == NULL)
        return -1;

    SecTaskRef sec_task = SecTaskCreateFromSelf(NULL);
    if(sec_task == NULL) 
        return -2;

    CFTypeRef entitlementValue = SecTaskCopyValueForEntitlement(sec_task, key, NULL);
    CFRelease(sec_task); // release SecTask ref

    if(entitlementValue == NULL)
        return -3;

    int ret = -4;
    if(CFGetTypeID(entitlementValue) == CFBooleanGetTypeID())
        ret = CFBooleanGetValue((CFBooleanRef)entitlementValue);
    CFRelease(entitlementValue);

    return ret;
}

BOOL isJITEnabled(BOOL useCSOPS) 
{
    if(!useCSOPS && getEntitlementIntValue(CFSTR("dynamic-codesigning")) == 1)
        return YES;

    int flags;
    csops(getpid(), 0, &flags, sizeof(flags));
    return (flags & CS_DEBUGGED) != 0;
}

BOOL isAppSandboxed()
{
    int noConatainer = getEntitlementIntValue(CFSTR("com.apple.private.security.no-container"));
    int noSandbox = getEntitlementIntValue(CFSTR("com.apple.private.security.no-sandbox"));
    int containerRequired = getEntitlementIntValue(CFSTR("com.apple.private.security.container-required"));
    
    // The app is sandboxed if:
    // - "com.apple.private.security.no-container" is false
    // - "com.apple.private.security.no-sandbox" is false
    // - "com.apple.private.security.container-required" is true
    // ref: https://github.com/opa334/TrollStore#unsandboxing
    return ( noConatainer == 0 || noSandbox == 0 || containerRequired == 1 );
}

BOOL isTrollStoreEnvironment() 
{
    NSString *tsPath = [NSString stringWithFormat:@"%@/../_TrollStore", NSBundle.mainBundle.bundlePath];
    return (access([tsPath fileSystemRepresentation], F_OK) == 0) ? YES : NO;
}