#!/usr/bin/sed -f
# Source: http://lists.samba.org/archive/linux/2002-August/004283.html

# If no /* get next. 
/\/\*/!b

# Here we've got an /*, append lines until get the corresponding */. 
:x
/\*\//!{
N
bx
}

# Delete /*...*/, emulating a non-greedy match. 
s@/\*\([^*]*\|\*\+[^/]\)*\*/@@g
 
