#import "utils.h"
#import "fishhook/fishhook.h"

typedef struct __SecTask * SecTaskRef;
extern CFTypeRef SecTaskCopyValueForEntitlement(
        SecTaskRef task, 
        NSString* entitlement, 
        CFErrorRef  _Nullable *error
    ) 
    __attribute__((weak_import));

extern SecTaskRef SecTaskCreateFromSelf(CFAllocatorRef allocator)
    __attribute__((weak_import));

BOOL getEntitlementValue(NSString *key) 
{
    if (SecTaskCreateFromSelf == NULL || SecTaskCopyValueForEntitlement == NULL)
        return NO;
    SecTaskRef sec_task = SecTaskCreateFromSelf(NULL);
    if(!sec_task) return NO;
    CFTypeRef value = SecTaskCopyValueForEntitlement(sec_task, key, nil);
    if (value != nil) 
    {
        CFRelease(value);
    }
    CFRelease(sec_task);
    return value != nil && [(__bridge id)value boolValue];
}

BOOL isJITEnabled() 
{
    if (getEntitlementValue(@"dynamic-codesigning")) 
    {
        return YES;
    }
    int flags;
    csops(getpid(), 0, &flags, sizeof(flags));
    return (flags & CS_DEBUGGED) != 0;
}

void ShowAlert(NSString* title, NSString* message)
{
    DISPATCH_ASYNC_START
        UIWindow* mainWindow = [[UIApplication sharedApplication] windows].lastObject;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"ok!"
                                                style:UIAlertActionStyleDefault
                                                handler:nil]];
        [mainWindow.rootViewController presentViewController:alert
                                                    animated:true
                                                completion:nil];
    DISPATCH_ASYNC_CLOSE
}
