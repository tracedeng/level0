//
//  Constance.h
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#ifndef Constance_h
#define Constance_h

#ifdef DEBUG
#define ACCOUNTURL @"http://localhost:8000/account"
#define CONSUMERURL @"http://localhost:8000/consumer"
#define MERCHANTURL @"http://localhost:8000/merchant"
#define CREDITURL @"http://localhost:8000/credit"
#define FLOWTURL @"http://localhost:8000/flow"
#define QINIUURL @"http://7xor5x.com1.z0.glb.clouddn.com"
#else
#define CONSUMERURL @"http://localhost/consumer"
#define MERCHANTURL @"http://localhost/merchant"
#define CREDITURL @"http://localhost/credit"
#define FLOWTURL @"http://localhost/flow"
#endif

#endif /* Constance_h */


