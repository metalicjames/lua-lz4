UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
# linux config
LUA_INCDIR ?= /usr/include/lua5.3
LUA_LIBDIR ?= /usr/lib
LIBFLAGS   ?= -shared
LUALIB     ?= lz4.so
LUA_CFLAGS ?= -O2 -fPIC
endif
ifeq ($(UNAME), Darwin)
# macosx config
LUA_INCDIR ?= /usr/local/opt/lua/include
LUA_LIBDIR ?= /usr/local/opt/lua/lib
LIBFLAGS   ?= -bundle -undefined dynamic_lookup -all_load
LUALIB     ?= lz4.so
LUA_CFLAGS ?= -O2 -fPIC
endif
ifeq ($(UNAME), x86_64-w64-mingw32)
# mingw-w64 config
LUA_INCDIR ?= /usr/local/mingw/include/
LUA_LIBDIR ?= /usr/local/mingw/lib
LIBFLAGS ?= -shared 
LUALIB ?= lz4.dll
LIBS ?= -llua
endif

LZ4OBJS     = lz4/lz4.o lz4/lz4hc.o lz4/lz4frame.o lz4/xxhash.o

CMOD        = $(LUALIB)
OBJS        = lua_lz4.o

CFLAGS      = $(LUA_CFLAGS) -I$(LUA_INCDIR)
CXXFLAGS    = $(LUA_CFLAGS) -I$(LUA_INCDIR)
LDFLAGS     = $(LIBFLAGS) -L$(LUA_LIBDIR)


# rules

all: lz4

install: $(CMOD)
	cp $(CMOD) $(INST_LIBDIR)

clean:
	$(RM) $(CMOD) $(OBJS) $(LZ4OBJS)

lz4: $(OBJS) $(LZ4OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(LZ4OBJS) -o $(CMOD) $(LIBS)
