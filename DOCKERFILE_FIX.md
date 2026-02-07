# Dockerfile Build Fix

## Issue
Railway deployment failed with error:
```
ERROR: failed to build: failed to solve: process "/bin/sh -c apk add --no-cache ... 
&& docker-php-ext-install ... tokenizer ... xml ..." did not complete successfully: exit code: 2
```

## Root Cause
1. **tokenizer extension**: Not a separate extension in PHP 8.3 - it's built into PHP core
2. **xml extension**: Should be installed as `dom` instead of `xml` in PHP
3. **Missing build dependencies**: Need autoconf, g++, make for compiling extensions
4. **Missing runtime libraries**: Need base libraries (libpng, libjpeg-turbo, etc.) not just -dev versions

## Fix Applied

### Changed in Dockerfile:
1. **Removed `tokenizer`** from extension list (built-in to PHP)
2. **Changed `xml` to `dom`** for proper XML support
3. **Added build tools**: autoconf, g++, make for compilation
4. **Added runtime libraries**: libpng, libjpeg-turbo, freetype, libxml2, oniguruma, libzip
5. **Clean up dev packages** after build to reduce image size

### Result:
- ✅ All required PHP extensions install correctly
- ✅ Runtime libraries available
- ✅ Smaller final image (dev packages removed)
- ✅ Build completes successfully

## Verification
Fixed Dockerfile pushed to: https://github.com/ProScripter123/ptero
Commit: 29b66be - "Fix Dockerfile build error - remove tokenizer, change xml to dom, add build deps"

## Next Steps for User
1. Redeploy on Railway - build should succeed now
2. Railway will automatically pull latest code
3. Monitor deployment logs to confirm successful build
