. MRAS JCL script
//assign NAME=CLKTD6X
.DO #NAME# (I) - to import source from host
//if I
import #NAME#.asm #NAME#/asm:1
//end
sim f
mras #NAME#/asm:1 +o=#NAME#:1 -nm-ne-nc-we
mlink -a=y,#NAME#:1-n=:1-e
sim s
