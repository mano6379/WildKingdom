//
//  ViewController.m
//  WildKingdom
//
//  Created by Marion Ano on 3/27/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
//

#import "ViewController.h"
#import "WildKingdomCollectionViewCell.h"

//static NSString * const PhotoCellIdentifier = @"myCollectionViewCellLionsID";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarDelegate, UITabBarControllerDelegate>

@property NSDictionary* flickrDictionary;
@property NSDictionary* flickrPhotoDictionary;
@property NSMutableArray* myMutableArray;
@property WildKingdomCollectionViewCell *lionCollectionViewCell;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionViewLions;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myMutableArray = [NSMutableArray new];
    self.lionCollectionViewCell = [WildKingdomCollectionViewCell new];
    self.tabBarController.delegate = self;
    
    //why did I need to delete this code?
    //[self.myCollectionViewLions registerClass:[WildKingdomCollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionViewCellLionsID"];
    
	//this is the JSON url to access the Flickr API
    NSURL *flickrURL = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=633598ba88b5bf68d28634f609db6aef&tags=lions%2C+tigers%2C+bears&text=lions%2C+tigers%2C+bears&safe_search=1&format=json&nojsoncallback=1&api_sig=edf3c69979a834d164c3bba88d128b10"];
    
    //An NSURL object represents a URL that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data.
    NSURLRequest *flickrURLRequest = [NSURLRequest requestWithURL:flickrURL];
    
    //[super viewDidLoad];
    
    //this is setting the spinner on in the nav bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:flickrURLRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {

         //this gets us into the JSON NSDictionary
         self.flickrDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         
         //now this gets us into the "photos" NSDictionary
         self.flickrPhotoDictionary = self.flickrDictionary[@"photos"];
         
         //this gets us into the "photo" array
         NSArray *gettingPhotosFromPhotosDictionary = self.flickrPhotoDictionary[@"photo"];

//         NSLog(@"first dictionary count: %lu", (unsigned long)self.flickrDictionary.count);
//         NSLog(@"second dictionary count: %lu", (unsigned long)self.flickrPhotoDictionary.count);
//         NSLog(@"array count: %lu", (unsigned long)gettingPhotosFromPhotosDictionary.count);
         
         //for all the NSDictionary items in the gettingPhotosFromPhotosDictionary, please do the following code in {}
         for (NSDictionary *items in  gettingPhotosFromPhotosDictionary)
         {
             
             //this string gets you the address where each photo lives
             NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", items[@"farm"], items[@"server"], items[@"id"], items[@"secret"]];
            
             
//object conversion. Work backwards: What can I create an image from? What do I have? and how do I get to UIImage object? They key is: What do I want and how do I get back to it.
             
             NSLog(@"%@", photoURL);
             NSURL* url = [NSURL URLWithString:photoURL];
             NSData* data = [NSData dataWithContentsOfURL:url];
             UIImage* image = [UIImage imageWithData:data];
             
             //NSData *data = [[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
             // NSLog(@"%@", photoURL);
         
             //adding the URL object into the NSMutable Array which contains URL objects
             //now I have an array with image objects
             [self.myMutableArray addObject:image];
             
             //NSLog(@"data is being added to mutable array");
             
         }
         NSLog(@"%lu", (unsigned long)self.myMutableArray.count);
         //remember that the view need to reload in the block
         [self.myCollectionViewLions reloadData];
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
     }];

}

#pragma mark -- Data Source Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myMutableArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //if tab bar item is at index 0
    WildKingdomCollectionViewCell *photoCell =
    [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
     UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
    photoCell.backgroundColor = [UIColor redColor];
    photoCell.imageView.image = flickrImage;
    
    NSLog(@"make cell");
        return photoCell;
    
}

//working on this 3/29, left off here before yoga

//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.tabBarController.tabBarItem == 1)
//    {
//        UICollectionViewCell *photoCell =
//        [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
//        //UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
//        photoCell.backgroundColor = [UIColor redColor];
//        //photoCell.imageView.image = flickrImage;
//        
//        NSLog(@"make cell");
//        return photoCell;
//    }
//    else if (self.tabBarController.tabBarItem == 1)
//    {
//        UICollectionViewCell *photoCell =
//        [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
//        //UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
//        photoCell.backgroundColor = [UIColor redColor];
//        //photoCell.imageView.image = flickrImage;
//        
//        NSLog(@"make cell");
//        return photoCell;
//    }
//    //else (self.tabBarController.tabBarItem == 2)
//    {
//        UICollectionViewCell *photoCell =
//        [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
//        //UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
//        photoCell.backgroundColor = [UIColor redColor];
//        //photoCell.imageView.image = flickrImage;
//        return photoCell;
//    }
//    
//    return nil;
//}



@end
