//
//  EPCallCarCell.h
//  EPin-IOS
//
//  Created by jeader on 16/6/17.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPCallCarCell : UITableViewCell
/**
*  cell1
*/
//@property (weak, nonatomic) IBOutlet UITextField *contectTF;
@property (weak, nonatomic) IBOutlet UIButton *upCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *destinetionBtn;
@property (weak, nonatomic) IBOutlet UIButton *containBtn;
/**
 *  cell2
 */
@property (weak, nonatomic) IBOutlet UILabel *countingLab;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) IBOutlet UIImageView * mapAnimationVi;
/**
 *  cell3
 */
@property (weak, nonatomic) IBOutlet UIButton *driverDetail;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIImageView * carAnimationVi;

/**
 *  cell4
 */
@property (nonatomic, weak) IBOutlet UIButton * upCarTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *upCarBtn1;
@property (weak, nonatomic) IBOutlet UIButton *destinetionBtn1;
@property (weak, nonatomic) IBOutlet UIButton *containBtn1;
/**
 *  cell5
 */
@property (nonatomic, weak) IBOutlet UIImageView * onCarImageVi;


@end
