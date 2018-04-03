This document provides some notes concerning Indy 9.0.4 beta.

============================================
Winsock 2
============================================

In Windows 95, your program may raise an EIdWS2StubError exception with the message
"Error on loading Winsock2 library (WS2_32.DLL)". This happens because Indy 9.0
requires Winsock 2 to be installed and Winsock 2 is not installed on Windows 95
by default.  Your users should install a FREE Winsock 2 update that is available
at:

http://www.microsoft.com/windows95/downloads/contents/wuadmintools/s_wunetworkingtools/w95sockets2/default.asp

This is particularly important because it does fix some bugs in the original
Winsock 1.1 stack included in Windows 95.   We decided to base Indy on the
Winsock 2 specification because that has a better API than Winsock 1.1.

We have included a DLL in your Indy \Source\WS2DetectDLL directory that can be
used in your installation programs to help determine if the user needs to
install Winsock 2.  We also include sample Wise Installation
System and Inno Setup scripts that illustrate how to use the .DLL in your
installations.  Documentation for this is in the README.htm in that directory.
We include the original pascal source-code and the source-code for the port to
assembly language.

============================================
IdAntiFreeze
============================================

Starting with this version of Indy, the IdAntiFreeze unit is now in the design-
time packages instead of the run-time packages. This change was required so that
the Indy run-time package does not depend upon the VCL GUI in Win32 and CLX in
Linux. TIdAntiFreeze is unique in that it is the only run-time unit that is
permitted to link with GUI units such as Forms. That was triggering a dependency
on the VCL in the run-time unit package.  For C++Builder, we include a directive
that forces the IdAntiFreeze object file to be directly linked into the program
that uses Indy even if the developer is using run-time packages.

============================================
IdCompressionIntercept
============================================

You may sometimes get the following compiler errors with this file:

IdCompressionIntercept.pas(331) Error: Incompatible types
IdCompressionIntercept.pas(152) Error: Unsatisfied forward or external declaration: '_tr_init'
IdCompressionIntercept.pas(153) Error: Unsatisfied forward or external declaration: '_tr_tally'
IdCompressionIntercept.pas(154) Error: Unsatisfied forward or external declaration: '_tr_flush_block'
IdCompressionIntercept.pas(155) Error: Unsatisfied forward or external declaration: '_tr_align'
IdCompressionIntercept.pas(156) Error: Unsatisfied forward or external declaration: '_tr_stored_block'
IdCompressionIntercept.pas(157) Error: Unsatisfied forward or external declaration: 'adler32'
IdCompressionIntercept.pas(158) Error: Unsatisfied forward or external declaration: 'inflate_blocks_new'
IdCompressionIntercept.pas(159) Error: Unsatisfied forward or external declaration: 'inflate_blocks'
IdCompressionIntercept.pas(160) Error: Unsatisfied forward or external declaration: 'inflate_blocks_reset'
IdCompressionIntercept.pas(161) Error: Unsatisfied forward or external declaration: 'inflate_blocks_free'
IdCompressionIntercept.pas(162) Error: Unsatisfied forward or external declaration: 'inflate_set_dictionary'
IdCompressionIntercept.pas(163) Error: Unsatisfied forward or external declaration: 'inflate_trees_bits'
IdCompressionIntercept.pas(164) Error: Unsatisfied forward or external declaration: 'inflate_trees_dynamic'
IdCompressionIntercept.pas(165) Error: Unsatisfied forward or external declaration: 'inflate_trees_fixed'
IdCompressionIntercept.pas(166) Error: Unsatisfied forward or external declaration: 'inflate_trees_free'
IdCompressionIntercept.pas(167) Error: Unsatisfied forward or external declaration: 'inflate_codes_new'
IdCompressionIntercept.pas(168) Error: Unsatisfied forward or external declaration: 'inflate_codes'
IdCompressionIntercept.pas(169) Error: Unsatisfied forward or external declaration: 'inflate_codes_free'
IdCompressionIntercept.pas(170) Error: Unsatisfied forward or external declaration: '_inflate_mask'
IdCompressionIntercept.pas(171) Error: Unsatisfied forward or external declaration: 'inflate_flush'
IdCompressionIntercept.pas(172) Error: Unsatisfied forward or external declaration: 'inflate_fast'
IdCompressionIntercept.pas(189) Error: Unsatisfied forward or external declaration: 'deflateInit_'
IdCompressionIntercept.pas(196) Error: Unsatisfied forward or external declaration: 'deflate'
IdCompressionIntercept.pas(203) Error: Unsatisfied forward or external declaration: 'deflateEnd'
IdCompressionIntercept.pas(213) Error: Unsatisfied forward or external declaration: 'inflateInit_'
IdCompressionIntercept.pas(220) Error: Unsatisfied forward or external declaration: 'inflate'
IdCompressionIntercept.pas(227) Error: Unsatisfied forward or external declaration: 'inflateEnd'
IdCompressionIntercept.pas(234) Error: Unsatisfied forward or external declaration: 'inflateReset'
Indy40.dpk(196) Fatal: Could not compile used unit 'IdCompressionIntercept.pas'

Do not be alarmed.  This is due to a bug in DCC32 in Delphi 4, 5, 6, plus
C++Builder, 4, 5, and 6.

There is a work around for this issue.  The work around is to compile this unit
separately from the other units and than build Indy with a command such as
DCC32 using the /M parameter.  Do NOT use the /B parameter as that does force
everything to be recompiled triggering the DCC32 error.

The batch files FULLC4.BAT, FULLC5.BAT, FULLC6.BAT, FULLD4.BAT, FULLD5.BAT and
FULLD6.BAT now have the work around in them so we recommend that you use those to
build Indy.

Borland is aware of the issue.

============================================
Delphi 4 Standard
============================================

Borland Delphi 4 Standard Edition is longer supported.

We have become painfully aware of an issue with this Delphi version and Indy 9.0.
The issue is that Borland did not include the SyncObjs unit in that version.
Unfortunately, Indy 9.0 requires that unit.  We had tried to deal with this
limitation by writing a unit that implements what we had needed
(TCriticalSection).  Unfortunately, that has not worked out at all for Indy 9.0,
we need to use other things in the SyncObjs unit, we need to facilitate further
growth in Indy, and we have concentrate our focus on Indy itself rather than
rewriting some thread functionality for both Win32 and Linux.

Thus, we are in a painful position.  We could try to avoid use of SyncObjs but
that we would have a harder time using some advanced multi-threading techniques
that have become necessary. We doubt that this work would really be a good idea
just to keep supporting a small minority of users.   Thus, we have to do a
difficult thing and that is to stop supporting Delphi 4 Standard Edition users
so we can better support a larger user base.

If you still are using Delphi 4 Standard, you still have the following options:

1) Keep using Indy 8.0 because that does work with Delphi 4 Standard Edition
2) Try using other component sets such as Internet Component Suite.  There are
other component sets available commercially that may work
3) Upgrade to a later version of Delphi such as Borland Delphi 6 Personal
Edition for personal use only or purchase Delphi 6.0 Professional
Edition.

============================================
C++Builder Notes
============================================

Starting with this version of Indy, we are discontinuing our C++Builder .BPK's.
This does not mean dropping C++Builder support at all but we are implementing it
in a different way.  It turns out that C++Builder support can be achieved by
compiling Indy with some special parameters and than making a .LIB for it.
Interestingly enough, C++Builder generates it's binaries for Pascal units by
using MAKE and MAKE calls DCC32 to generate the object (.OBJ) files and the
header (.HPP) files for the units and MAKE also call TLIB to make the library
(.LIB) for C++Builder programs. In other words, it's really just the same
process.

We admit that using .BPK's is very intuitive.  On the other hand, it is becoming
problematic for Indy.  Indy is build on a run-time only package and a
design-time-only package architecture.  This is necessary because Borland has
stopped distributing property editor .DCU's and the EULA prohibits using those
in end-user executable programs anyway. Indy now does something slightly different
in that there is now a run-time unit (IdAntiFreeze.pas) in the design-time package
along with a directive to force C++Builder to link the object into your
application even if you are using run-time packages.  Unfortunately, we found a
problem with this in the C++Builder .BPK's.  The issue is that in the design-time
.BPK's, an object header file (.HPP) and an object file (.OBJ) are not generated
in design-time .BPK's at all meaning that TIdAntiFreeze could not be used. We
never did use the .BPK's to make the Indy C++Builder files at all.  We use
DCC32 and TLIB to make the Indy binaries with a process similar to what the
FULLC*.BAT files are doing.

============================================
Delphi 6 and C++Builder 6 Library Paths
============================================

You should remove Indy 8.0 with Borland's MSI installer by using the Add/Remove
control panel applet.

In Delphi 6.0 and C++Builder 6.0, Indy should be listed in your path before the
standard Borland RTL Paths. This is important because Borland does include an
older version of Indy in their distributions and this old distribution can
conflict with our distribution.  In earlier installations, we used to delete
some files from your lib\debug directory but this is not workable in C++Builder
6.0 because the old Indy distribution was placed in several paths.  This was
occurring even though you removed Indy with Borland's MSI installer or
specifically chose not to delete Indy 9.0.  We did not feel comfortable deleting
those Indy files because there are so many files in several paths because that
would increase the chance that we would make an error and delete something we
should not have deleted causing some other problems.

============================================
C++Builder 6.0
============================================

The original C++Builder 6.0 Enterprise and Professional distributions had a bug
that causes failures when compiling Pascal Source-code.  Symptoms of the problem
range from an inability to install third party components or debug VCL source
code to the generation of error messages such as:

[Pascal Fatal Error]  Unable to build. License is invalid or has expired.
[Pascal Fatal Error]  Bad file format: 'C:\WINNT\System32\vcl50.dcp'
[Linker Fatal Error]  Fatal: Unable to open file 'PASCALCOMPONENTS.OBJ'

There is a free update that fixes this bug on the C++Builder 6.0 registered
User's web-site at

 http://www.borland.com/devsupport/bcppbuilder/registered_users/

The Indy installer for C++Builder 6.0 will check for the original version of
C++Builder and warn you about this.
