CLKLSDOS
========

TRS-80 Emulator Clock Set Utility for TRSDOS 6.x/LS-DOS 6.3.1L
-----------------------------------------------------------

This repository contains source code for building utilities to set the TRS-80 system date and time in the emulator from the host system clock, and the related /CMD files.

The supported emulators implement the access to the host system clock via the following IN ports:
- 68H: the seconds (0-59);
- 69H: the minutes (0-59);
- 6AH: the hours (0-23);
- 6BH: the day (1-31);
- 6CH: the month (1-12);
- 6DH: the year (00-99 for LS-DOS 6.3.1L, 80-87 for TRSDOS 6.x).

Four versions of the utility are provided:
- `CLKTD6X`: for TRSDOS 6.x with date format `MM/DD/YY`;
- `CLKTD6XE`: for TRSDOS 6.x with date format `DD/MM/YY`;
- `CLKLD63X`: for LS-DOS 6.3.1L with date format `MM/DD/YY`;
- `CLKL63XE`: for LS-DOS 6.3.1L with date format `DD/MM/YY`.

`CLKLD63X` and `CLKL63XE` only: if the emulated system does not implement the access to the host clock, it will request the user to enter the current date and time at the first system boot (even if called from JCL). The date will be saved with checksum in RAM at addresses 00A0H-00A3H. At subsequent system boots, only the time will be requested.


That's it.  Enjoy !

Best regards,

Michel Bernard (michel_bernard@icloud.com)
