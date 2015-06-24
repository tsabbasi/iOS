//
//  PhotosViewController.m
//  Photo Bomber
//
//  Created by Taha Abbasi on 5/19/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "DetailViewController.h"
#import "PresentDetailTransition.h"
#import "DismissDetailTransition.h"

#import <SimpleAuth/SimpleAuth.h>


@interface PhotosViewController () <UIViewControllerTransitioningDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) BOOL loading;
@property (nonatomic) NSString *tag;
@end

@implementation PhotosViewController

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    
    self.navigationItem.rightBarButtonItem.enabled = !_loading;
}

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"#Photos";
    _tag = @"places";
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    self.navigationItem.leftBarButtonItem = searchButton;
    
    
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        
        // the scope likes, comments, follow is not currently allowed by instagram for consumer facing apps. so the like functionality will not work.
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            
            self.accessToken = responseObject[@"credentials"][@"token"];
            
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            
            [self refresh];
            
        }];
    } else {
        [self refresh];
    }
}

- (void)search {
    
    UIAlertView *hashTagSearch = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Enter a tagsearch e.g. beautiful earth" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];

    hashTagSearch.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * searchTextField = [hashTagSearch textFieldAtIndex:0];
    searchTextField.keyboardType = UIKeyboardTypeDefault;
    searchTextField.placeholder = @"Enter search e.g. places";
    hashTagSearch.tag = 1;
    
    [hashTagSearch show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        NSString *normalizedTag = [[alertView textFieldAtIndex:0].text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSString *legalizedNormalizedTag = [[normalizedTag componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
        _tag = legalizedNormalizedTag;
        if ([_tag length] <= 0 || buttonIndex == 0) {
            return;
        } else {
            [self refresh];
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }

}

- (void)refresh {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@&count=40", _tag, self.accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"Network Error!" message:@"Sorry, There Seems To Be A Problem With The Network. Please Make Sure Your Wifi/Cellular Data is On, Or Try Again Later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settigns", nil];
                networkAlert.tag = 2;
                [networkAlert show];
                
            });
        } else {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            self.photos = [responseDictionary valueForKeyPath:@"data"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                
            });
        }
    }];
    [task resume];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *photo = self.photos[indexPath.row];
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    viewController.photo = photo;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return [[PresentDetailTransition alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[DismissDetailTransition alloc] init];
}



@end
