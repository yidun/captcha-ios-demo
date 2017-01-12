

// Import the Header
#import "NTESVCJailbreakCheck.h"

// Imports
#import <TargetConditionals.h>
#import <sys/stat.h>
#include <sys/sysctl.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

#define PIRACYTHRESHOLD 1

// Failed piracy checks
enum {
    // Failed the Piracy Check
    KFPirated = 994832,
    // Failed the Encryption Finding Main Symbol Check
    KFEFMS = 102937,
    // Failed the Encryption Check
    KFEncryption = 11291,
    // Failed Finding Encryption Info
    KFEncryptInfo = 77632,
    // Failed the User ID Check
    KFUserID = 392823,
    // Failed the CodeSig Check
    KFCodeSig = 3823492,
    // Failed the PkgInfo Check
    KFPkgCheck = 112203,
    // Failed FileManager EXE Check
    KFFileEXE = 271721,
    // Failed FileManager Plist Check
    KFPlistCheck = 32532,
    // Failed Honeypot Check 1
    KFHoneypot1 = 845834,
    // Failed Honeypot Check 2
    KFHoneypot2 = 845835,
    // Failed Honeypot Check 3
    KFHoneypot3 = 845836,
} VCPiratedChecks;
// Failed jailbroken checks
enum {
    // Failed the Jailbreak Check
    KFJailbroken = 3429542,
    // Failed the OpenURL Check
    KFOpenURL = 321,
    // Failed the Cydia Check
    KFCydia = 432,
    // Failed the Inaccessible Files Check
    KFIFC = 47293,
    // Failed the plist check
    KFPlist = 9412,
    // Failed the Processes Check with Cydia
    KFProcessesCydia = 10012,
    // Failed the Processes Check with other Cydia
    KFProcessesOtherCydia = 42932,
    // Failed the Processes Check with other other Cydia
    KFProcessesOtherOCydia = 10013,
    // Failed the FSTab Check
    KFFSTab = 9620,
    // Failed the System() Check
    KFSystem = 47475,
    // Failed the Symbolic Link Check
    KFSymbolic = 34859,
    // Failed the File Exists Check
    KFFileExists = 6625,
} VCJailbrokenChecks;

/* Piracy Check Definitions */

// Define the encryption information (if needed)
#if TARGET_IPHONE_SIMULATOR && !defined(LC_ENCRYPTION_INFO)
#define LC_ENCRYPTION_INFO 0x21
struct encryption_info_command {
    uint32_t cmd;
    uint32_t cmdsize;
    uint32_t cryptoff;
    uint32_t cryptsize;
    uint32_t cryptid;
};
#endif

// Code Signature and PkgInfo Definitions
#define CODE_SIG    @"_CodeSignature"
#define PKGINFO     @"PkgInfo"


/* End Piracy Check Definitions */

/* Jailbreak Check Definitions */

// Define the filesystem check
#define FILECHECK [NSFileManager defaultManager] fileExistsAtPath:
// Define the exe path
#define EXEPATH [[NSBundle mainBundle] executablePath]
// Define the plist path
#define PLISTPATH [[NSBundle mainBundle] infoDictionary]

// Jailbreak Check Definitions
#define CYDIA       @"MobileCydia"
#define OTHERCYDIA  @"Cydia"
#define OOCYDIA     @"afpd"
#define CYDIAPACKAGE    @"cydia://package/com.fake.package"
#define CYDIALOC        @"/Applications/Cydia.app"
#define HIDDENFILES     [NSArray arrayWithObjects:@"/Applications/RockApp.app",@"/Applications/Icy.app",@"/usr/sbin/sshd",@"/usr/bin/sshd",@"/usr/libexec/sftp-server",@"/Applications/WinterBoard.app",@"/Applications/SBSettings.app",@"/Applications/MxTube.app",@"/Applications/IntelliScreen.app",@"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",@"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",@"/private/var/lib/apt",@"/private/var/stash",@"/System/Library/LaunchDaemons/com.ikey.bbot.plist",@"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",@"/private/var/tmp/cydia.log",@"/private/var/lib/cydia", @"/etc/clutch.conf", @"/var/cache/clutch.plist", @"/etc/clutch_cracked.plist", @"/var/cache/clutch_cracked.plist", @"/var/lib/clutch/overdrive.dylib", @"/var/root/Documents/Cracked/", nil]

/* End Jailbreak Definitions */

// Kill System Call Definition
#define KILL "killall SpringBoard"

@implementation NTESVCJailbreakCheck

#pragma mark - User Methods


// Is the application running on a jailbroken device?
+ (int)isJailbroken {
    
    // Is the device jailbroken?
    #if TARGET_IPHONE_SIMULATOR
    // It's the developer
    return NOTJAIL;
    
    #else
    // Make an int to monitor how many checks are failed
    int motzart = 0;
    
    // URL Check
    /*if ([self urlCheck] != NOTJAIL) {
     // Jailbroken
     motzart += 3;
     }*/
    
    // Cydia Check
    if ([self cydiaCheck] != NOTJAIL) {
        // Jailbroken
        motzart += 3;
    }
    
    // Inaccessible Files Check
    if ([self inaccessibleFilesCheck] != NOTJAIL) {
        // Jailbroken
        motzart += 2;
    }
    
    // Plist Check
    if ([self plistCheck] != NOTJAIL) {
        // Jailbroken
        motzart += 2;
    }
    
    // Processes Check
    /*if ([self processesCheck] != NOTJAIL) {
     // Jailbroken
     motzart += 2;
     }*/
    
    // FSTab Check
    if ([self fstabCheck] != NOTJAIL) {   //这里
        // Jailbroken
        motzart += 1;
    }
    
    // Shell Check
    if ([self systemCheck] != NOTJAIL) {
        // Jailbroken
        motzart += 2;
    }
    
    // Symbolic Link Check
    if ([self symbolicLinkCheck] != NOTJAIL) {
        // Jailbroken
        motzart += 2;
    }
    
    // FilesExist Integrity Check
    if ([self filesExistCheck] != NOTJAIL) {
        // Jailbroken
        motzart += 2;
    }
    
    // Check if the Jailbreak Integer is 3 or more
    if (motzart >= 3) {
        // Jailbroken
        return KFJailbroken;
    }
    
    // Not Jailbroken
    return NOTJAIL;
    
    #endif

}


#pragma mark - Static Piracy Checks

// Honeypot checks, throwing them off ;) - Hehehe

// Is the device jailbroken?  Always TRUE
+ (BOOL)isTheDeviceJailbroken {
    return YES;
}

// Is the application pirated?  Always TRUE
+ (BOOL)isTheApplicationCracked {
    return YES;
}

// Is the application tampered with?  Always TRUE
+ (BOOL)isTheApplicationTamperedWith {
    return YES;
}

#pragma mark - Static Jailbreak Checks

// UIApplication CanOpenURL Check
+ (int)urlCheck {
    @try {
        // Create a fake url for cydia
        NSURL *FakeURL = [NSURL URLWithString:CYDIAPACKAGE];
        // Return whether or not cydia's openurl item exists
        if ([[UIApplication sharedApplication] canOpenURL:FakeURL])
            return KFOpenURL;
        else
            return NOTJAIL;
    }
    @catch (NSException *exception) {
        // Error, return false
        return NOTJAIL;
    }
}

// Cydia Check
+ (int)cydiaCheck {
    @try {
        // Create a file path string
        NSString *filePath = CYDIALOC;
        struct stat s;
        // Check if it exists
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            // It exists
            return KFCydia;
        } else if(!stat([filePath UTF8String], &s)){
            return KFCydia;
        }else {
            // It doesn't exist
            return NOTJAIL;
        }
    }
    @catch (NSException *exception) {
        // Error, return false
        return NOTJAIL;
    }
}

// Inaccessible Files Check
+ (int)inaccessibleFilesCheck {
    @try {
        // Run through the array of files
        for (NSString *key in HIDDENFILES) {
            // Check if any of the files exist (should return no)
            if ([[NSFileManager defaultManager] fileExistsAtPath:key]) {
                // Jailbroken
                return KFIFC;
            }
        }
        
        // Shouldn't get this far, return jailbroken
        return NOTJAIL;
    }
    @catch (NSException *exception) {
        // Error, return false
        return NOTJAIL;
    }
}

// Plist Check
+ (int)plistCheck {
    @try {
        // Define the Executable name
        NSString *ExeName = EXEPATH;
        NSDictionary *ipl = PLISTPATH;
        // Check if the plist exists
        if ([FILECHECK ExeName] == FALSE || ipl == nil || ipl.count <= 0) {
            // Executable file can't be found and the plist can't be found...hmmm
            return KFPlist;
        } else {
            // Everything is good
            return NOTJAIL;
        }
    }
    @catch (NSException *exception) {
        // Error, return false
        return NOTJAIL;
    }
}

// Running Processes Check
/*+ (int)processesCheck {
    @try {
        // Make a processes array
        NSArray *processes = [self runningProcesses];
        
        // Check for Cydia in the running processes
        for (NSDictionary * dict in processes) {
            // Define the process name
            NSString *process = [dict objectForKey:@"ProcessName"];
            // If the process is this executable
            if ([process isEqualToString:CYDIA]) {
                // Return Jailbroken
                return KFProcessesCydia;
            } else if ([process isEqualToString:OTHERCYDIA]) {
                // Return Jailbroken
                return KFProcessesOtherCydia;
            } else if ([process isEqualToString:OOCYDIA]) {
                // Return Jailbroken
                return KFProcessesOtherOCydia;
            }
        }
        
        // Not Jailbroken
        return NOTJAIL;
    }
    @catch (NSException *exception) {
        // Error
        return NOTJAIL;
    }
}*/

// FSTab Size
+ (int)fstabCheck {
    @try {
        struct stat sb;
        stat("/etc/fstab", &sb);
        long long size = sb.st_size;
        if (size == 80) {
            // Not jailbroken
            return NOTJAIL;
        } else
            // Jailbroken
            return KFFSTab;
    }
    @catch (NSException *exception) {
        // Not jailbroken
        return NOTJAIL;
    }
}

// System() available
+ (int)systemCheck {
    @try {
        // See if the system call can be used
        if (system(0)) {
            // Jailbroken
            return KFSystem;
        } else
            // Not Jailbroken
            return NOTJAIL;
    }
    @catch (NSException *exception) {
        // Not Jailbroken
        return NOTJAIL;
    }
}

// Symbolic Link available
+ (int)symbolicLinkCheck {
    @try {
        // See if the Applications folder is a symbolic link
        struct stat s;
        if (lstat("/Applications", &s) != 0) {
            if (s.st_mode & S_IFLNK) {
                // Device is jailbroken
                return KFSymbolic;
            } else
                // Not jailbroken
                return NOTJAIL;
        } else {
            // Not jailbroken
            return NOTJAIL;
        }
    }
    @catch (NSException *exception) {
        // Not Jailbroken
        return NOTJAIL;
    }
}

// FileSystem working correctly?
+ (int)filesExistCheck {
    @try {
        // Check if filemanager is working
        if (![FILECHECK [[NSBundle mainBundle] executablePath]]) {
            // Jailbroken and trying to hide it
            return KFFileExists;
        } else
            // Not Jailbroken
            return NOTJAIL;
    }
    @catch (NSException *exception) {
        // Not Jailbroken
        return NOTJAIL;
    }
}

// Get the running processes
/*+ (NSArray *)runningProcesses {
    // Define the int array of the kernel's processes
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    // Make a new size and int of the sysctl calls
    size_t size;
    int st = 0;
    
    // Make new structs for the processes
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    // Do get all the processes while there are no errors
    do {
        // Add to the size
        size += size / 10;
        // Get the new process
        newprocess = realloc(process, size);
        // If the process selected doesn't exist
        if (!newprocess){
            // But the process exists
            if (process){
                // Free the process
                free(process);
            }
            // Return that nothing happened
            return nil;
        }
        
        // Make the process equal
        process = newprocess;
        
        // Set the st to the next process
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    // As long as the process list is empty
    if (st == 0){
        
        // And the size of the processes is 0
        if (size % sizeof(struct kinfo_proc) == 0){
            // Define the new process
            int nprocess = size / sizeof(struct kinfo_proc);
            // If the process exists
            if (nprocess){
                // Create a new array
                NSMutableArray * array = [[NSMutableArray alloc] init];
                // Run through a for loop of the processes
                for (int i = nprocess - 1; i >= 0; i--){
                    // Get the process ID
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    // Get the process Name
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    // Get the process Priority
                    NSString *processPriority = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_priority];
                    // Get the process running time
                    NSDate   *processStartDate = [NSDate dateWithTimeIntervalSince1970:process[i].kp_proc.p_un.__p_starttime.tv_sec];
                    // Create a new dictionary containing all the process ID's and Name's
                    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processPriority, processName, processStartDate, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessPriority", @"ProcessName", @"ProcessStartDate", nil]];
                    
                    // Add the dictionary to the array
                    [array addObject:dict];
                }
                // Free the process array
                free(process);
                
                // Return the process array
                return array;
                
            }
        }
    }
    
    if (process) {
        free(process);
    }
    // If no processes are found, return nothing
    return nil;
}*/

@end
