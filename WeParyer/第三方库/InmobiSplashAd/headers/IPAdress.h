//
//  IPAdress.h
//  WeParyer
//
//  Created by Jeccy on 16/8/15.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

#ifndef IPAdress_h
#define IPAdress_h

#include <stdio.h>

#define MAXADDRS	32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes

void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();


#endif /* IPAdress_h */
