//
//  InboxViewController.m
//  Moments
//
//  Created by Taha Abbasi on 5/14/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "InboxViewController.h"
#import "LoginViewController.h"
#import "ImageViewController.h"
#import "MSCellAccessory.h"

@interface InboxViewController ()
{
    PFQuery *_query;
}
@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    PFUser *currentUser = [PFUser currentUser];
    _query = [PFQuery queryWithClassName:@"Messages"];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
        [self retrieveMessages];
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    UIColor *disclosureColor = [UIColor colorWithRed:0.769 green:0.765 blue:0.773 alpha:1.00];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:disclosureColor];
    
    NSString *fileType = [message objectForKey:@"fileType"];
    
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    } else {
        // File type is video
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        
        [self.moviePlayer prepareToPlay];
        
        
        // Add it to the view controller so we can see it
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    // Delete it!
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    NSLog(@"Recipients: %@", recipientIds);
    
    if ([recipientIds count] == 1) {
        // Last recipient - delete!
        [self.selectedMessage deleteInBackground];
    } else {
        // Remove the recipient and save it
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"] ) {
        
        LoginViewController *lvc = (LoginViewController *)segue.destinationViewController;
        [lvc setHidesBottomBarWhenPushed:YES];
        
    } else if ([segue.identifier isEqualToString:@"showImage"]) {
        ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
        [ivc setHidesBottomBarWhenPushed:YES];
        
        ivc.message = self.selectedMessage;
        
    }
}

#pragma mark - IBActions

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

#pragma mark - Helper methods

- (void)retrieveMessages {
    [_query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [_query orderByDescending:@"createdAt"];
    [_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            // we found messages
            self.messages = objects;
            [self.tableView reloadData];
        }
        
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        
    }];
}

@end
