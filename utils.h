#if __has_feature(modules)
@import UIKit;
@import Foundation;
#else
#import "UIKit/UIKit.h"
#import "Foundation/Foundation.h"
#endif

#define DISPATCH_ASYNC_START dispatch_async(dispatch_get_main_queue(), ^{
#define DISPATCH_ASYNC_CLOSE });

#define PT_TRACE_ME 0
extern int ptrace(int, pid_t, caddr_t, int);

#define CS_DEBUGGED 0x10000000
extern int csops(
        pid_t pid, 
        unsigned int ops,
        void *useraddr, 
        size_t usersize
    );

extern BOOL getEntitlementValue(NSString *key);
extern BOOL isJITEnabled();

#define DLOG(format, ...) ShowAlert(@"DEBUG", [NSString stringWithFormat:@"\n %s [Line %d] \n %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:format, ##__VA_ARGS__]])
extern void ShowAlert(NSString* title, NSString* message);