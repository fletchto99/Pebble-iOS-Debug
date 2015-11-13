#define kBundlePath @"/Library/MobileSubstrate/DynamicLibraries/com.fletchto99.pebbledebug.bundle"
#define flexPath "/Library/MobileSubstrate/DynamicLibraries/com.fletchto99.pebbledebug.bundle/libFLEX.dylib"

@interface PBDashboardOption 
-(void)setOptionString:(id)arg1;
-(void)setAnalyticsIdentifier:(id)arg1;
-(void)setOptionImage:(id)arg1;
-(id)optionString;
@end

@interface PBDashboardTableViewCell : UITableViewCell
-(id)optionLabel;
@end

@interface PBAdvanceAppGestures
-(void)showTestViewController;
@end

@interface PBTableViewController
-(id)tableView;
@end

@interface PBDebugViewController : PBTableViewController
@end

%hook PBDashboardDefaultSettingsView
 
-(void)setOptions:(id)options {
    NSLog(@"bananatime");

    NSMutableArray* mutableOptions = [options mutableCopy];

    NSBundle *bundle = [[[NSBundle alloc] initWithPath:kBundlePath] autorelease];      
    NSString *imagePath = [bundle pathForResource:@"debug" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

    PBDashboardOption *debugOption = [[%c(PBDashboardOption) alloc] init];
    if (debugOption) {
        [debugOption setOptionString:@"Debug"];
        [debugOption setAnalyticsIdentifier:@"DeveloperSettings"];
        [debugOption setOptionImage:image];
        [mutableOptions insertObject:debugOption atIndex:0];
    }
    
    NSArray *newOptions = [mutableOptions copy];
    %orig(newOptions);
}

-(void)handleTapGesture:(UITapGestureRecognizer *)sender {
    NSLog(@"bananatime");
    PBDashboardTableViewCell *cell = (PBDashboardTableViewCell *)sender.view;
    UILabel *label = (UILabel *)[cell optionLabel];

    if ([label.text isEqualToString:@"DEBUG"]) {

        NSString *text = [[NSBundle mainBundle] bundleIdentifier];
        if ([text containsString:@"pebbletime"]) {
            PBAdvanceAppGestures *gestureController = [[%c(PBAdvanceAppGestures) alloc] init];
            [gestureController showTestViewController];
        } else {
            [%c(PBAdvanceAppGestures) showTestViewController];
        }

        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Caution" message:@"Please use carefully! There may be settings in here which can damage your Pebble. Don't use them if you don't know what you are doing!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [warning show];
        [warning release];
    } else {
        sender.view.tag = sender.view.tag-1;
        %orig(sender);
    }
}
%end

%hook PBDebugViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return %orig + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

     NSLog(@"Bananatime");

    if ([indexPath row] == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%d. FLEX Debugger", (int)(indexPath.row + 1)];
    } else {
        cell = %orig(tableView, indexPath);
    }
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"Bananatime");

    if ([indexPath row] == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        if (!NSClassFromString(@"FLEXManager")) {
            dlopen("/Library/MobileSubstrate/DynamicLibraries/com.fletchto99.pebbledebug.bundle/libFLEX.dylib", RTLD_NOW);
        }
        
        Class FLEXManager = NSClassFromString(@"FLEXManager");
        id sharedManager = [FLEXManager performSelector:@selector(sharedManager)];
        [sharedManager performSelector:@selector(showExplorer)];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        %orig(tableView, indexPath);
    }
}

%end