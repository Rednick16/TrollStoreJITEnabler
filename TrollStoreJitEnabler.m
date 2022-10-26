#import <spawn.h>
#import <dlfcn.h>
#import "utils.h"

extern char** environ;

int tryEnableJIT(int argc, char **argv) 
{
    int result = 0;
    if (getppid() != 1) 
    {
        NSLog(@"parent pid is not launchd, calling ptrace(PT_TRACE_ME)");
        // Child process can call to PT_TRACE_ME
        // then both parent and child processes get CS_DEBUGGED
        result = ptrace(PT_TRACE_ME, 0, 0, 0);
        // FIXME: how to kill the child process?
    }

    if (getEntitlementValue(@"com.apple.private.security.no-container") 
    || getEntitlementValue(@"com.apple.private.security.container-required") 
    || getEntitlementValue(@"com.apple.private.security.no-sandbox")) 
    {
        NSLog(@"[+] Sandbox is disabled, trying to enable JIT");
        int pid;
        int ret = posix_spawnp(&pid, argv[0], NULL, NULL, argv, environ);
        if (ret == 0) 
        {
            // posix_spawn is successful, let's check if JIT is enabled
            int retries;
            for (retries = 0; retries < 10; retries++) 
            {
                usleep(10000);
                if (isJITEnabled()) 
                {
                    NSLog(@"[+] JIT has heen enabled with PT_TRACE_ME");
                    retries = -1;
                    result = 1;
                    break;
                }
            }
            if (retries != -1) 
            {
                NSLog(@"[+] Failed to enable JIT: unknown reason");
                result = 0;
            }
        }
        else 
        {
            NSLog(@"[+] Failed to enable JIT: posix_spawn() failed errno %d", errno);
            result = 0;
        }
    }
    else
    {
        result = -1;
    }
    return result;
}

__attribute__((constructor)) static void entry(int argc, char **argv) 
{
    int result = tryEnableJIT(argc, argv);
    if(result == 1)
        ShowAlert(@"Success", @"JIT is enabled.\nMade with ❤️ by Red16 :)");
    if(result == 0)
        ShowAlert(@"Error", @"Failed to enable JIT: unknown reason");
    if(result == -1)
        ShowAlert(@"Error", @"application is sandboxed.");
}