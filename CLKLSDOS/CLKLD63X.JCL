. MRAS JCL SCRIPT
//assign N=CLKLD63X
.DO #N# (I) to import source from host - (O) to import _ORIG file
//if O
import -n #N#_ORIG.asm #N#/asm:1
//else
//if I
import -n #N#.asm #N#/asm:1
//end
//end
//PAUSE
sim f
mras #N#/asm:1 +o=#N#:1 -gc-nm-ne-nc-nh-we
sim s
