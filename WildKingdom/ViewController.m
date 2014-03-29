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

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    //NSString *apiKey;
}
//api - b540bffdef2e4be5e90462d0c2bf7cbf
// secret  - b2a362d69dea7b69

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
    //apiKey = @"b7be76edbd3b906f271fdc997561a95e";
    
    
    [self.myCollectionViewLions registerClass:[WildKingdomCollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionViewCellLionsID"];

    //NSString* tags = @"=lions+tigers+bears";
    //NSString* texts = @"text=lion+tiger+bear";
    
	//this is the JSON url to access the Flickr API
    NSURL *flickrURL = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=9fc87a455f82c80f42b3c707da70fc77&tags=lions%2C+tigers%2C+bears&text=lions%2C+tigers%2C+bears&safe_search=1&format=json&nojsoncallback=1&auth_token=72157643086193585-0b4b7242fede7a1c&api_sig=d2a8f53af5357b2b0fb2e636af0132d0"];
    
    //An NSURL object represents a URL that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data.
    NSURLRequest *flickrURLRequest = [NSURLRequest requestWithURL:flickrURL];
    
    [super viewDidLoad];
    
    [NSURLConnection sendAsynchronousRequest:flickrURLRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {

         //this gets us into the JSON NSDictionary
         self.flickrDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         
         //now this gets us into the second NSDictionary
         self.flickrPhotoDictionary = self.flickrDictionary[@"photos"];
         
         NSArray *gettingPhotosFromPhotosDictionary = self.flickrPhotoDictionary[@"photo"];
//         NSLog(@"first dictionary count: %lu", (unsigned long)self.flickrDictionary.count);
//         NSLog(@"second dictionary count: %lu", (unsigned long)self.flickrPhotoDictionary.count);
//         NSLog(@"array count: %lu", (unsigned long)gettingPhotosFromPhotosDictionary.count);
         
         //for all the NSDictionary items in the gettingPhotosFromPhotosDictionary, please do the following code in {}
         for (NSDictionary *items in  gettingPhotosFromPhotosDictionary)
         {
             //create a string with the NSURL object being called by the stringWithFormat method.
             
             NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", items[@"farm"], items[@"server"], items[@"id"], items[@"secret"]];
             //this turns the
             
             //object conversion, question is what can I create an image from. What do I have and how do I get to UIImage object. What do I want and how do I get back to it.
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
         
     }];

}

#pragma mark -- Data Source Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myMutableArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WildKingdomCollectionViewCell *photoCell =
    [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
     UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
    photoCell.imageView.image = flickrImage;
    
    NSLog(@"make cell");
    return photoCell;
    
}


@end
