#import <Foundation/Foundation.h>
#import "ApplicationMain.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	[[[ApplicationMain alloc] init] run];

    [pool drain];
    return 0;
}
