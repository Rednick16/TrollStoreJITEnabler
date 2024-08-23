<<<<<<< HEAD
# TrollStoreJitEnabler

you can use sideloadly to inject this tweak into your app which supports Jit.
=======
# TrollStoreJITEnabler

You can use sideloadly to inject this tweak into your app which supports JIT.
>>>>>>> cef3644 (update 1.1.0)

# Unsandboxing
```
<key>com.apple.private.security.container-required</key>
<false/>
```
```
<key>com.apple.private.security.no-container</key>
<true/>
```
```
<key>com.apple.private.security.no-sandbox</key>
<true/>
```
<<<<<<< HEAD
ProvaLauncher also used this entitlement with one of the above
```
<key>com.apple.private.security.storage.AppDataContainers</key>
<true/>
```
=======
>>>>>>> cef3644 (update 1.1.0)

# Based on
https://github.com/PojavLauncherTeam/PojavLauncher_iOS/commit/ccaa9416f182dad0bc26832cbec85b799ae47dad#diff-0b345163bfb92b086397dec9b5f5f475cb6610283e8fb5c722763e6fb3d39db0
