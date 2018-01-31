//
//  ISpyWordsViewController.m
//  Janie
//
//  Created by This One on 7/31/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "ISpyWordsViewController.h"
#import "WebViewController.h"
#import "ModelController.h"
#import "DataViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"


@interface ISpyWordsViewController ()

@end

@implementation ISpyWordsViewController {
    NSArray *_titles;
    NSMutableArray *_actions;
    WebViewController *webViewController;
}

- (void)viewDidLoad {
    _titles = @[@"Read book by yourself",@"Leer el libro por ti mismo",
                @"Listen to the book",@"Eschucha el libro",
                @"Seth sings the book!",@"¡Seth canta el libro!",
                @"Get to know / Conoce a Seth"];
    
    [self.actionsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"actionThing"];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"actionThing" forIndexPath:indexPath];
 
 // Configure the cell...
     cell.textLabel.text = _titles[indexPath.row];
     cell.textLabel.textAlignment = NSTextAlignmentCenter;
     CGRect r = cell.contentView.bounds;
     cell.textLabel.frame = r;
 return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger numItems = _titles.count;
    if (indexPath.row == numItems-1) {
        [self loadWebGuy];
    } else {
        NSUInteger readOrPlay = 0;
        NSUInteger englishOrSpanish = 2;
//        BOOL autoPlay = 0;
        
        switch (indexPath.row) {
            case 0: {
                readOrPlay = 0;
                break;
            }
            case 1: {
                readOrPlay = 0;
                englishOrSpanish = 1;

                break;
            }
            case 2: {
                readOrPlay = 1;

                break;
            }
            case 3: {
                readOrPlay = 1;
                englishOrSpanish = 1;
           
                break;
            }
            case 4: {
                readOrPlay = 2;
                break;
            }
            case 5: {
                englishOrSpanish = 1;
                readOrPlay = 2;
                break;
            }
                
            default:
                break;
        }
    
        [[NSUserDefaults standardUserDefaults] setInteger:readOrPlay forKey:@"ReadOrPlayMusic"];
        [[NSUserDefaults standardUserDefaults] setInteger:englishOrSpanish forKey:@"WhichLanguage"];
        
//        [[NSUserDefaults standardUserDefaults] setBool:autoPlay forKey:@"AutoPlay"];

        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // simply go to page 3 and it should JUST WORK!
        [(RootViewController *)ROOT_VIEW_CONTROLLER goToFirstPage];
        

        
    }
    [self.actionsTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadWebGuy {
    webViewController = [[WebViewController alloc]initWithNibName:nil bundle:nil];
    webViewController.owner = self;
    [self presentViewController:webViewController animated:YES completion:^{
        
    }];
}

- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
