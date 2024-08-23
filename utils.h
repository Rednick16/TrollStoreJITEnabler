#if __has_feature(modules)
@import UIKit;
@import Foundation;
#else
#import "UIKit/UIKit.h"
#import "Foundation/Foundation.h"
#endif

#define PT_TRACE_ME 0
#define PT_DETACH 11
extern int ptrace(int, pid_t, caddr_t, int);

#define CS_DEBUGGED 0x10000000
extern int csops(
        pid_t pid, 
        unsigned int ops,
        void *useraddr, 
        size_t usersize
    );

extern BOOL isJITEnabled(BOOL useCSOPS);
extern BOOL isAppSandboxed(void);
extern BOOL isTrollStoreEnvironment(void);