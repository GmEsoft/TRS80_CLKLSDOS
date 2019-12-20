. MRAS JCL SCRIPT
//assign N=CLKL63XE
.DO #N# (I) to import source from host - (O) to import _ORIG file
//if O
import -n #N#_ORIG.asm #N#/asm:2
//else
//if I
import -n #N#.asm #N#/asm:2
//end
//end
//PAUSE
sim f
mras #N#/asm:2 +o=#N#:2 -gc-nm-ne-nc-nh-we
sim s
#N#:2
