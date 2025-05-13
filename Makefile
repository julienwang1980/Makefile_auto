# ========================================
# 目录设置
# ========================================
D_TOP       := $(shell pwd)
D_SRC       := $(D_TOP)/src
D_H         := $(D_TOP)/head
D_OBJ       := $(D_TOP)/obj
D_MK        := $(D_TOP)/dmk

# ========================================
# 编译器设置
# ========================================
CC		:= gcc
CFLAGS		:= -Wall -Wextra -I$(D_H) -MMD -MP
LDFLAGS		:= -lm

# ========================================
# 查找所有源文件（递归）
SRC_C       := $(shell find $(D_SRC) -name "*.c")
OBJ_C       := $(patsubst $(D_SRC)/%.c, $(D_OBJ)/%.o, $(SRC_C))
DEP_FILES   := $(patsubst $(D_OBJ)/%.o, $(D_MK)/%.d, $(OBJ_C))

# ========================================
# 默认目标
# ========================================
TARGET      := target.bin
all: $(TARGET)

# ========================================
# 生成最终程序
$(TARGET): $(OBJ_C)
	@echo Linking $@
	$(CC) $^ -o $@ $(LDFLAGS)

# ========================================
# 编译 .c -> .o 并生成 .d 文件（支持子目录）
$(D_OBJ)/%.o: $(D_SRC)/%.c
	@mkdir -p $(dir $@) $(dir $(patsubst $(D_OBJ)/%.o,$(D_MK)/%.d,$@))
	@echo Compiling $<
	$(CC) $(CFLAGS) -c $< -o $@ -MF $(patsubst $(D_OBJ)/%.o,$(D_MK)/%.d,$@)

# ========================================
# 包含依赖文件（静默处理不存在）
-include $(DEP_FILES)

# ========================================
# 清理
# ========================================
clean:
	@echo Cleaning...
	@rm -rf $(D_OBJ) $(D_MK) $(TARGET)

.PHONY: all clean