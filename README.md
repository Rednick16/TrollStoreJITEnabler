# TrollStoreJitEnabler

You can use Sideloadly to inject this tweak into your app which supports JIT.

# Unsandboxing
```
<key>com.apple.developer.kernel.extended-virtual-addressing</key>
<true/>
```
```
<key>com.apple.developer.kernel.increased-memory-limit</key>
<true/>
```
```
<key>com.apple.private.security.no-sandbox</key>
<true/>
```
PojavLauncher also used these entitlements with the ones above:
```
<key>com.apple.private.security.storage.AppDataContainers</key>
<true/>
```
```
<key>com.apple.private.security.storage.MobileDocuments</key>
<true/>
```

# Based on
https://github.com/PojavLauncherTeam/PojavLauncher_iOS/commit/ccaa9416f182dad0bc26832cbec85b799ae47dad#diff-0b345163bfb92b086397dec9b5f5f475cb6610283e8fb5c722763e6fb3d39db0
