VPATH = src head#查找多个目录,查找依赖时如果遇到%.c,则自动到src目录下寻找
# 指定生成的终极目录文件
TATGET = test.bin
# 指定当前所在目录
# cur_mkfile = $(abspath $(lastword $(MAKEFILE_LIST)))  #获取当前正在执行的makefile的绝对路径
# D_TOP = $(dir $(cur_mkfile))
D_TOP = $(shell pwd)
# 指定文件目录
D_SRC = $(D_TOP)/src
D_H = $(D_TOP)/head
# 指定编译器
# CROSS_COMPILER = arm-linux-
CC = $(CROSS_COMPILER)gcc
# 指定编译选项
CFLAGS = -I$(D_H) -Wall -lm

# 指定.o文件目录
D_OBJ = obj
# 指定.d文件目录
D_MK = dmk


# wildcard表示把$(D_SRC)目录下的.c文件遍历出来
# SRC_C   = $(wildcard $(D_SRC)/*.c)
 # foreach表示遍历$(D_SRC)的所有子目录同时把子目录下的.c文件遍历出来
SRC_C   = $(foreach dir, $(D_SRC), $(wildcard $(dir)/*.c))

# notdir表示去除目录，则$(notdir $(SRC_C))表示a.c b.c
# patsubst表示把$(notdir $(SRC_C))中的.c替换成.o,即a.o b.o
# addprefix表示增加前缀$(D_OBJ)/,则OBJ_C变量表示为obj/a.o obj/b.o
OBJ_C   = $(addprefix $(D_OBJ)/,$(patsubst %.c,%.o,$(notdir $(SRC_C))))
SRC_MK  = $(addprefix $(D_MK)/, $(patsubst %.c,%.d,$(notdir $(SRC_C))))


$(TATGET):$(OBJ_C)
	$(CC) $^ $(CFLAGS) -o $@

$(D_OBJ)/%.o: %.c %.h
	$(CC) $(CFLAGS) -c $< -o $@

#下面的这个模式规则中的$@.$$$$是当前这条进程执行过程中，临时产生的一个文件，之后对这个文件进行替换，替换完毕之后，删除这个临时的文件
$(D_MK)/%.d: %.c %.h
	$(CC) $(CFLAGS) $< -MM > $@.$$$$; \
		sed 's/$*.o: /$*.o $*.d: /' $@.$$$$ > $@; \
	rm -vf $@.$$$$
sinclude $(SRC_MK)

clean:
	rm -rf $(D_OBJ)/* $(TATGET) $(D_MK)/*

.PHONY: clean
