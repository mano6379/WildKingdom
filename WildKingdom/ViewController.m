//
//  ViewController.m
//  WildKingdom
//
//  Created by Marion Ano on 3/27/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
//  FlickrAPIKey = @"633598ba88b5bf68d28634f609db6aef";

#import "ViewController.h"
#import "WildKingdomCollectionViewCell.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarDelegate>
{
    NSString* tags;
    CGRect viewOneFrame;
}

@property NSDictionary* flickrDictionary;
@property NSDictionary* flickrPhotoDictionary;
@property NSMutableArray* myMutableArray;
@property WildKingdomCollectionViewCell *lionCollectionViewCell;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionViewLions;
@property (strong, nonatomic) IBOutlet UITabBarItem *lionTabBarItem;
@property (strong, nonatomic) IBOutlet UITabBarItem *bearsTabBarItem;
@property (strong, nonatomic) IBOutlet UITabBarItem *tigerTapBarItem;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    tags = @"sealife";
    self.myMutableArray = [NSMutableArray new];
    [self searchPhotos];
//  self.lionCollectionViewCell = [WildKingdomCollectionViewCell new];
    
    
    //why did I need to delete this code?
    //[self.myCollectionViewLions registerClass:[WildKingdomCollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionViewCellLionsID"];
}

#pragma mark -- helper method
//helper method here to search for photos using tags:
-(void)searchPhotos
{
    //store incoming data into a string
     NSString *getPhotos = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a2771d1875542f34f36cfa340a824c39&tags=%@&per_page=18&format=json&nojsoncallback=1",tags];
    //An NSURL object represents a URL that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data.
    NSURL *url = [NSURL URLWithString:getPhotos];
    
    //NSURLRequest objects represent a URL load request
    NSURLRequest *flickrURLRequest = [NSURLRequest requestWithURL:url];
    
    //this is setting the spinner on in the nav bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //An NSURLConnection object lets you load the contents of a URL by providing a URL request object.
    [NSURLConnection sendAsynchronousRequest:flickrURLRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {

         //create a dictionary from the JSON String
         self.flickrDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         
         //create a second dictionary to get us into the "photos"
         self.flickrPhotoDictionary = self.flickrDictionary[@"photos"];
         
         //create an array which is filled with dictionary objects
         NSArray *gettingPhotosFromPhotosDictionary = self.flickrPhotoDictionary[@"photo"];

//         NSLog(@"first dictionary count: %lu", (unsigned long)self.flickrDictionary.count);
//         NSLog(@"second dictionary count: %lu", (unsigned long)self.flickrPhotoDictionary.count);
//         NSLog(@"array count: %lu", (unsigned long)gettingPhotosFromPhotosDictionary.count);
         
         //need to clear out what was previously in the array before adding new "searched" images back into the mutable array
         [self.myMutableArray removeAllObjects];
         //loop through each item in the NSDictionary in the array of dictionaries and then please do the following code in the curlies {}
         for (NSDictionary *items in  gettingPhotosFromPhotosDictionary)
         {
             //this string gets you the address where each photo lives. Note: farm, server, id, and secret are all dictionaries in the array
             NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", items[@"farm"], items[@"server"], items[@"id"], items[@"secret"]];
            
             
             //object conversion. Work backwards: What can I create an image from? What do I have? and how do I get to UIImage object? They key is: What do I want and how do I get back to it.
             NSLog(@"%@", photoURL);
             NSURL* url = [NSURL URLWithString:photoURL];
             NSData* data = [NSData dataWithContentsOfURL:url];
             UIImage* image = [UIImage imageWithData:data];
         
             //now I have an array with image objects
             [self.myMutableArray addObject:image];
             
             //NSLog(@"data is being added to mutable array");
             
         }
         //NSLog(@"%lu", (unsigned long)self.myMutableArray.count);
         //remember that the view needs to reload in the block
         [self.myCollectionViewLions reloadData];
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
     }];

}

#pragma mark -- delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myMutableArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WildKingdomCollectionViewCell *photoCell =
    [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
    UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
    photoCell.imageView.image = flickrImage;
    
    //NSLog(@"make cell");
    
    return photoCell;
}

//note: outlets above for each tab bar item
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //call "search" method here based on string that's inserted
    //[self search:@""];
    //reference tab bar item pushed gets you the data you want to display
    if (item.tag == 0)
    {
        tags = @"seaturles";
        [self searchPhotos];
    }
    
    else if (item.tag == 1)
    {
        tags = @"reeffish";
        [self searchPhotos];
    
    }
    else if (item.tag == 2)
    {
        tags = @"dolphins";
        [self searchPhotos];
    }

}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    if(fromInterfaceOrientation == UIUserInterfaceLayoutDirectionRightToLeft || fromInterfaceOrientation == UIUserInterfaceLayoutDirectionLeftToRight)
//    {
//        self.lionCollectionViewCell.frame = viewOneFrame;
//    }
//    else
//    {
//        self.lionCollectionViewCell.frame = CGRectMake(self.lionCollectionViewCell.frame.origin.x, self.lionCollectionViewCell.frame.origin.y, 200, 200);
//    }
//}


@end
