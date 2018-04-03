unit idShellFolder;

interface

uses
  Windows;

const
  CSIDL_ADMINTOOLS = $0030;
  // The file system directory that is used to store administrative tools for an individual user. The Microsoft Management Console (MMC) will save customized consoles to this directory, and it will roam with the user.
  CSIDL_ALTSTARTUP = $001d;
  // The file system directory that corresponds to the user's nonlocalized Startup program group.
  CSIDL_APPDATA = $001a;
  // The file system directory that serves as a common repository for application-specific data. A typical path is C:\Documents and Settings\username\Application Data. This CSIDL is supported by the redistributable Shfolder.dll for systems that do not have the Microsoft® Internet Explorer 4.0 integrated Shell installed.
  CSIDL_BITBUCKET = $000a;
  // The virtual folder containing the objects in the user's Recycle Bin.
  CSIDL_CDBURN_AREA = $003b;
  // The file system directory acting as a staging area for files waiting to be written to CD. A typical path is C:\Documents and Settings\username\Local Settings\Application Data\Microsoft\CD Burning.
  CSIDL_COMMON_ADMINTOOLS = $002f;
  // The file system directory containing administrative tools for all users of the computer.
  CSIDL_COMMON_ALTSTARTUP = $001e;
  // The file system directory that corresponds to the nonlocalized Startup program group for all users. Valid only for Microsoft Windows NT® systems.
  CSIDL_COMMON_APPDATA = $0023;
  // The file system directory containing application data for all users. A typical path is C:\Documents and Settings\All Users\Application Data.
  CSIDL_COMMON_DESKTOPDIRECTORY = $0019;
  // The file system directory that contains files and folders that appear on the desktop for all users. A typical path is C:\Documents and Settings\All Users\Desktop. Valid only for Windows NT systems.
  CSIDL_COMMON_DOCUMENTS = $002e;
  // The file system directory that contains documents that are common to all users. A typical paths is C:\Documents and Settings\All Users\Documents. Valid for Windows NT systems and Microsoft Windows® 95 and Windows 98 systems with Shfolder.dll installed.
  CSIDL_COMMON_FAVORITES = $001f;
  // The file system directory that serves as a common repository for favorite items common to all users. Valid only for Windows NT systems.
  CSIDL_COMMON_MUSIC = $0035;
  // The file system directory that serves as a repository for music files common to all users. A typical path is C:\Documents and Settings\All Users\Documents\My Music.
  CSIDL_COMMON_PICTURES = $0036;
  // The file system directory that serves as a repository for image files common to all users. A typical path is C:\Documents and Settings\All Users\Documents\My Pictures.
  CSIDL_COMMON_PROGRAMS = $0017;
  // The file system directory that contains the directories for the common program groups that appear on the Start menu for all users. A typical path is C:\Documents and Settings\All Users\Start Menu\Programs. Valid only for Windows NT systems.
  CSIDL_COMMON_STARTMENU = $0016;
  // The file system directory that contains the programs and folders that appear on the Start menu for all users. A typical path is C:\Documents and Settings\All Users\Start Menu. Valid only for Windows NT systems.
  CSIDL_COMMON_STARTUP = $0018;
  // The file system directory that contains the programs that appear in the Startup folder for all users. A typical path is C:\Documents and Settings\All Users\Start Menu\Programs\Startup. Valid only for Windows NT systems.
  CSIDL_COMMON_TEMPLATES = $002d;
  // The file system directory that contains the templates that are available to all users. A typical path is C:\Documents and Settings\All Users\Templates. Valid only for Windows NT systems.
  CSIDL_COMMON_VIDEO = $0037;
  // The file system directory that serves as a repository for video files common to all users. A typical path is C:\Documents and Settings\All Users\Documents\My Videos.
  CSIDL_CONTROLS = $0003;
  // The virtual folder containing icons for the Control Panel applications.
  CSIDL_COOKIES = $0021;
  // The file system directory that serves as a common repository for Internet cookies. A typical path is C:\Documents and Settings\username\Cookies.
  CSIDL_DESKTOP = $0000;
  // The virtual folder representing the Windows desktop, the root of the namespace.
  CSIDL_DESKTOPDIRECTORY = $0010;
  // The file system directory used to physically store file objects on the desktop (not to be confused with the desktop folder itself). A typical path is C:\Documents and Settings\username\Desktop.
  CSIDL_DRIVES = $0011;
  // The virtual folder representing My Computer, containing everything on the local computer: storage devices, printers, and Control Panel. The folder may also contain mapped network drives.
  CSIDL_FAVORITES = $0006;
  // The file system directory that serves as a common repository for the user's favorite items. A typical path is C:\Documents and Settings\username\Favorites.
  CSIDL_FONTS = $0014;
  // A virtual folder containing fonts. A typical path is C:\Windows\Fonts.
  CSIDL_HISTORY = $0022;
  // The file system directory that serves as a common repository for Internet history items.
  CSIDL_INTERNET = $0001;
  // A virtual folder representing the Internet.
  CSIDL_INTERNET_CACHE = $0020;
  // Version 4.72. The file system directory that serves as a common repository for temporary Internet files. A typical path is C:\Documents and Settings\username\Local Settings\Temporary Internet Files.
  CSIDL_LOCAL_APPDATA = $001c;
  // The file system directory that serves as a data repository for local (nonroaming) applications. A typical path is C:\Documents and Settings\username\Local Settings\Application Data.
  CSIDL_MYDOCUMENTS = $000c;
  // The virtual folder representing the My Documents desktop item. This should not be confused with CSIDL_PERSONAL, which represents the file system folder that physically stores the documents.
  CSIDL_MYMUSIC = $000d;
  // The file system directory that serves as a common repository for music files. A typical path is C:\Documents and Settings\User\My Documents\My Music.
  CSIDL_MYPICTURES = $0027;
  // The file system directory that serves as a common repository for image files. A typical path is C:\Documents and Settings\username\My Documents\My Pictures.
  CSIDL_MYVIDEO = $000e;
  // The file system directory that serves as a common repository for video files. A typical path is C:\Documents and Settings\username\My Documents\My Videos.
  CSIDL_NETHOOD = $0013;
  // A file system directory containing the link objects that may exist in the My Network Places virtual folder. It is not the same as CSIDL_NETWORK, which represents the network namespace root. A typical path is C:\Documents and Settings\username\NetHood.
  CSIDL_NETWORK = $0012;
  // A virtual folder representing Network Neighborhood, the root of the network namespace hierarchy.
  CSIDL_PERSONAL = $0005;
  // The file system directory used to physically store a user's common repository of documents. A typical path is C:\Documents and Settings\username\My Documents. This should be distinguished from the virtual My Documents folder in the namespace, identified by CSIDL_MYDOCUMENTS. To access that virtual folder, use SHGetFolderLocation, which returns the ITEMIDLIST for the virtual location, or refer to the technique described in Managing the File System.
  CSIDL_PRINTERS = $0004;
  // The virtual folder containing installed printers.
  CSIDL_PRINTHOOD = $001b;
  // The file system directory that contains the link objects that can exist in the Printers virtual folder. A typical path is C:\Documents and Settings\username\PrintHood.
  CSIDL_PROFILE = $0028;
  // The user's profile folder. A typical path is C:\Documents and Settings\username. Applications should not create files or folders at this level; they should put their data under the locations referred to by CSIDL_APPDATA or CSIDL_LOCAL_APPDATA.
  CSIDL_PROFILES = $003e;
  // The file system directory containing user profile folders. A typical path is C:\Documents and Settings.
  CSIDL_PROGRAM_FILES = $0026;
  // The Program Files folder. A typical path is C:\Program Files.
  CSIDL_PROGRAM_FILES_COMMON = $002b;
  // A folder for components that are shared across applications. A typical path is C:\Program Files\Common. Valid only for Windows NT, Windows 2000, and Windows XP systems. Not valid for Windows Millennium Edition (Windows Me).
  CSIDL_PROGRAMS = $0002;
  // The file system directory that contains the user's program groups (which are themselves file system directories). A typical path is C:\Documents and Settings\username\Start Menu\Programs.
  CSIDL_RECENT = $0008;
  // The file system directory that contains shortcuts to the user's most recently used documents. A typical path is C:\Documents and Settings\username\My Recent Documents. To create a shortcut in this folder, use SHAddToRecentDocs. In addition to creating the shortcut, this function updates the Shell's list of recent documents and adds the shortcut to the My Recent Documents submenu of the Start menu.
  CSIDL_SENDTO = $0009;
  // The file system directory that contains Send To menu items. A typical path is C:\Documents and Settings\username\SendTo.
  CSIDL_STARTMENU = $000b;
  // The file system directory containing Start menu items. A typical path is C:\Documents and Settings\username\Start Menu.
  CSIDL_STARTUP = $0007;
  // The file system directory that corresponds to the user's Startup program group. The system starts these programs whenever any user logs onto Windows NT or starts Windows 95. A typical path is C:\Documents and Settings\username\Start Menu\Programs\Startup.
  CSIDL_SYSTEM = $0025;
  // The Windows System folder. A typical path is C:\Windows\System32.
  CSIDL_TEMPLATES = $0015;
  // The file system directory that serves as a common repository for document templates. A typical path is C:\Documents and Settings\username\Templates.
  CSIDL_WINDOWS = $0024;
  // The Windows directory or SYSROOT. This corresponds to the %windir% or %SYSTEMROOT% environment variables. A typical path is C:\Windows.

function GetShellFolder(CSIDL: Integer): string;

implementation

type
  PSHItemID = ^TSHItemID;
  {$EXTERNALSYM _SHITEMID}
  _SHITEMID = record
    cb: Word;
    abID: array[0..0] of Byte;
  end;
  TSHItemID = _SHITEMID;
  {$EXTERNALSYM SHITEMID}
  SHITEMID = _SHITEMID;

type
  PItemIDList = ^TItemIDList;
  {$EXTERNALSYM _ITEMIDLIST}
  _ITEMIDLIST = record
     mkid: TSHItemID;
   end;
  TItemIDList = _ITEMIDLIST;
  {$EXTERNALSYM ITEMIDLIST}
  ITEMIDLIST = _ITEMIDLIST;

function SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer;
  var ppidl: PItemIDList): HResult; stdcall; external 'shell32.dll' name 'SHGetSpecialFolderLocation';

function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall; external 'shell32.dll' name 'SHGetPathFromIDListA';

function GetShellFolder(CSIDL: Integer): string;
var
  pidl: PItemIdList;
  FolderPath: string;
  SystemFolder: Integer;
begin
  SystemFolder := CSIDL;
  if SUCCEEDED(SHGetSpecialFolderLocation(0, SystemFolder, pidl)) then
  begin
    SetLength(FolderPath, max_path);
    if SHGetPathFromIDList(pidl, Pchar(FolderPath)) then
    begin
      SetLength(FolderPath, length(Pchar(FolderPath)));
    end;
  end;
  Result := FolderPath;
end;

end.
 