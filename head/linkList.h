#ifndef _LINK_LIST_H_
#define _LINK_LIST_H_

#define  _CRT_SECURE_NO_WARNINGS 
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define DEBUG(format, ...)\
	fprintf(stderr, "[DEBUG][%s:%d][%s][%s]"format, __FUNCTION__, __LINE__, __DATE__, __TIME__, ##__VA_ARGS__);//__VA_ARGS__ === a,b
#define ERROR(format, ...)\
	fprintf(stderr, "[ERROR][%s:%d][%s][%s]"format, __FUNCTION__, __LINE__, __DATE__, __TIME__, ##__VA_ARGS__);
#define LOG(format, ...)\
	fprintf(stderr, "[LOG][%s:%d][%s][%s]"format, __FUNCTION__, __LINE__, __DATE__, __TIME__, ##__VA_ARGS__);


//节点结构体
struct LinkNode
{
	void * data;//数据域
	struct LinkNode *next;//指针域
};

//链表结构体
struct LList
{
	struct LinkNode pHeader;	//头节点
	int m_Size;	//链表长度
};

//void * 别名
typedef void * LinkList;



//初始化链表
LinkList init_LinkList();

//插入节点
void insert_LinkList(LinkList list, int pos, void * data);

//遍历链表
void foreach_LinkList(LinkList list, void (*myPrint)(void *));

//删除链表节点，按位置删除
void removeByPos_LinkList(LinkList list, int pos);

//删除链表节点，按值删除
void removeByValue_LinkList(LinkList list, void *data, int(*myCompare)(void *, void *));

//返回链表长度
int size_LinkList(LinkList list);

//清空链表
void clear_LinkList(LinkList list);

//销毁列表
void destroy_LinkList(LinkList list);


//测试链表
void test_linkList();
#endif