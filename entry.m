#import <spawn.h>
#import <dlfcn.h>
#import "utils.h"

extern char** environ;

static int tryEnableJIT(int argc, char* *argv)
{
    if(isJITEnabled(YES))
    {
        NSLog(@"[+] JIT is already enabled.");
        return 1;
    }

    if( argc == 2 )
    {
        NSLog(@"[+] Calling ptrace(PT_TRACE_ME)");
        // Child process can call to PT_TRACE_ME
        // Then both parent and child processes get CS_DEBUGGED
        int ret = ptrace(PT_TRACE_ME, 0, 0, 0);
        return ret;
    }

    // If sandbox is disabled, W^X (Write XOR Execute) JIT can be enabled.
    if(!isAppSandboxed())
    {
        NSLog(@"[+] Sandbox is disabled, attempting to enable JIT");

        pid_t pid;
        int ret = posix_spawnp(&pid, argv[0], NULL, NULL, argv, environ);
        if(ret != 0)
        {
            NSLog(@"[-] Failed to spawn process: %s", strerror(ret));
            return 0;
        }

        int max_attempts = 10;
        int attempts = 0;
        BOOL jit_enabled = NO;

        do
        {
            if((jit_enabled = isJITEnabled(YES)))
            {
                NSLog(@"[+] JIT enabled with PT_TRACE_ME");
                break;
            }

            NSLog(@"[!] JIT not enabled yet, checking... (%d/%d)", ++attempts, max_attempts);
            usleep(100000); // 100ms

        } while(attempts < max_attempts);

        if(!jit_enabled) NSLog(@"[-] Failed to enable JIT."); // log failure
        
        // Cleanup
        ptrace(PT_DETACH, pid, NULL, 0);    // Detach from the child process
        kill(pid, SIGTERM);                 // Send SIGTERM to the child process
        waitpid(pid, NULL, 0);              // Wait for the child process to exit

        // 0 : Failure
        // 1 : Success
        return jit_enabled;
    }
    else
    {
        NSLog(@"[-] Application is sandboxed."); 
        return 2;
    }
}

__attribute__((constructor)) 
static void entry(int argc, char * argv[]) 
{
    NSLog(@"[Debug] entry() constructor called");
    
    if(!isTrollStoreEnvironment())
    {
        NSLog(@"[!] TrollStoreJITEnabler should only be run in a TrollStore environment.");
        return;
    }

    char *new_argv[] = { argv[0], "", NULL };

    int result = tryEnableJIT(argc, new_argv);

    NSLog(@"[Debug] tryEnableJIT() ret: %d", result);
}