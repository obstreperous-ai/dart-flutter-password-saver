//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_secure_storage_macos/flutter_secure_storage_macos-Swift.h>)
#import <flutter_secure_storage_macos/flutter_secure_storage_macos-Swift.h>
#else
@import flutter_secure_storage_macos;
#endif

#if __has_include(<path_provider_foundation/path_provider_foundation-Swift.h>)
#import <path_provider_foundation/path_provider_foundation-Swift.h>
#else
@import path_provider_foundation;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterSecureStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterSecureStoragePlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
}

@end
