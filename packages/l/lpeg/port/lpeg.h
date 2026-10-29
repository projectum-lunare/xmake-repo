#ifndef LPEG_H
#define LPEG_H

#if defined(__has_include)
#  if __has_include(<lua/lua.h>)
#    include <lua/lua.h>
#  else
#    include <lua.h>
#  endif
#else
#  include <lua.h>
#endif

#if defined(__cplusplus)
extern "C" {
#endif

int luaopen_lpeg(lua_State *L);

#if defined(__cplusplus)
}
#endif

#endif /* LPEG_H */
