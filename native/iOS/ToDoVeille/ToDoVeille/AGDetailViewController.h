//
//  AGDetailViewController.h
//  ToDoVeille
//
//  Created by Arthur GUIBERT on 16/12/2013.
//  Copyright (c) 2013 Arthur GUIBERT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
