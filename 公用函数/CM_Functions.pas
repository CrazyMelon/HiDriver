unit CM_functions;

interface

uses Winapi.Windows,Registry,ShlObj,ActiveX,ComObj,System.SysUtils,Winapi.ShellAPI,
     Winapi.Messages,Vcl.Forms,System.Classes,Vcl.ComCtrls;

var FileCount:Integer;
{1、设置开机启动}
function AutoPowerOnSet(
                        exename,                        //程序名字 application.name
                        desc:string                     //程序描述
                        ): Integer;
{2、关闭开机启动}
function AutoPowerOnDelete(
                        exename,                        //程序名字 application.name
                        desc:string                     //程序描述
                        ): Integer;

{3、关联应用程序}
function SetAssociatedExec(
                           FileExt,                     //程序后缀（如.exe）
                           Filetype,                    //文件类型（注册表相关）
                           FileDescription,             //文件描述
                           MIMEType,
                           ExecName,                    //程序名  Application.ExeName
                           IcoName: string;             //图标地址
                           Parameter:Integer               //参数
                           ): Boolean;                  {修改成功,返回True,否则False}

{4、创建桌面快捷方式}
function CreateShortcutOnDesktop(
                                 strExeFileName,        // 快捷程序名  Application.ExeName
                                 strParameters,         // 运行参数
                                 strHint: string        // 提示描述（鼠标移到上面的提示）
                                 ): boolean;

{5、查找文件}
procedure SearchPath(
                     path,                              //文件路径
                     filename: string;                  //文件名
                     list: TStrings;                    //
                     status: TStatusPanel               //
                     ); stdcall;

{6、获取电脑磁盘}
function getPath(
                 items: TStrings                        //搜寻磁盘结果
                 ): Integer;

{7、判断文件是否正在使用 }
function IsFileInUse(
                    fName: string                       //文件名
                    ): boolean;

{8、创建桌面快捷方式 }
procedure CreateShortCut(
                         const sPath: string;          //文件全路径
                         sShortCutName: WideString     //快捷名
                         );

{9、删除桌面快捷方式 }
procedure DeleteShortCut(
                         sShortCutName: WideString     //快捷名
                         );

{10、程序运行后删除自身 }
procedure DeleteSelf;

{11、取文件的主文件名 }
function GetMainFileName(AFileName: string): string;

{12、检测允许试用的天数是否已到期 }
function CheckTrialDays(AllowDays: Integer): Boolean;

{13、保存日志文件 }
procedure AddLogFile(
                     sInfoStr: string                   //日志内容
                     );

{14、获取文件版本号}
function GetFileVersion(
                        FileName: string                  //文件名
                        ): string;
{************************************************************************************************************}
implementation

{设置开机启动}
function AutoPowerOnSet(
                        exename,                        //程序名字
                        desc:string                     //程序描述
                        ): Integer;
var
  reg: TRegistry; //声明一个TRegistry类变量
begin
    reg := Tregistry.create;
    reg.rootkey := HKEY_LOCAL_MACHINE;
    if reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true) then
    begin
      if not reg.keyexists(exename) then //if not exist ,add it!
        reg.writestring('delphi test', exename);
      reg.CloseKey; //关闭注册表
    end;
    reg.Free; //释放变量所占内存
end;

{关闭开机启动}
function AutoPowerOnDelete(
                           exename,                        //程序名字
                           desc:string                     //程序描述
                           ): Integer;
var
  reg: TRegistry; //声明一个TRegistry类变量
begin
  begin
    reg := Tregistry.create;
    reg.rootkey := HKEY_LOCAL_MACHINE;
    if reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true) then
    begin
//    if reg.keyexists(Application.ExeName) then //if not exist ,add it!
      reg.DeleteValue('delphi test');
      reg.CloseKey; //关闭注册表
    end;
    reg.Free; //释放变量所占内存
  end;
end;

{关联应用程序}
function SetAssociatedExec(
                           FileExt,                     //程序后缀（如.exe）
                           Filetype,                    //文件类型（注册表相关）
                           FileDescription,             //文件描述
                           MIMEType,
                           ExecName,                    //程序名  Application.ExeName
                           IcoName: string;             //图标地址
                           Parameter:Integer
                           ): Boolean;                  {修改成功,返回True,否则False}
var
  Reg: TRegistry;
begin
  Result := False; {}
  if (FileExt = '') or (ExecName = '') then Exit;
  Reg := TRegistry.Create;
  with Reg do
  begin
    try
      RootKey := HKey_Classes_Root;
      if not OpenKey(FileExt, True) then  Exit;
      WriteString('', FileType);
      CloseKey;
      if MIMEType <> '' then
      WriteString('Content Type', MIMEType);
      CloseKey;
      if not OpenKey(FileType, True) then Exit;
      WriteString('', FileDescription);
      CloseKey;
      if not OpenKey(FileType + '\' + 'shell\open\command', True) then  Exit;
      WriteString('', '"' + ParamStr(0) + '"%1'+' '+inttostr(Parameter));
      CloseKey;
      OpenKey(FileType + '\' + '\DefaultIcon', True);
      WriteString('', IcoName);
      CloseKey;
      Result := True;
    finally
      Reg.Free;
    end;
 //SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_IDLIST,nil,nil);  //刷新显示
  end;
end;

{创建桌面快捷方式}
function CreateShortcutOnDesktop(
                                 strExeFileName,        // 快捷程序名  Application.ExeName
                                 strParameters,         // 运行参数
                                 strHint: string        // 提示描述（鼠标移到上面的提示）
                                 ): boolean;
var
  registerTemp: TRegistry;
  strDesktopDirectory: widestring;
  shelllinkTemp: IShellLink;
  persistfileTemp: IPersistFile;
  StartupDirectory: array[0..MAX_PATH] of Char;
  PIDL: PItemIDList;
begin
  registerTemp := TRegistry.Create;
//建立一个Registry实例
  with registerTemp do
  begin
    RootKey := HKEY_CURRENT_USER;
//设置根键值为HKEY_CURRENT_USER
//找到Software\MicroSoft\Windows\CurrentVersion\Explorer\Shell Folders
    if not OpenKey('Software\MicroSoft\Windows\CurrentVersion\Explorer\Shell Folders', True) then
//写入自己程序的信息
    begin
      result := false;
      exit;
    end;
//读取项目Desktop的值，即Desktop的实际路径
    strDesktopDirectory := ReadString('Desktop');
//善后处理
    CloseKey;
    Free;
  end;

//设置快捷方式的参数
  shelllinkTemp := CreateComObject(CLSID_ShellLink) as IShellLink;
  with shelllinkTemp do
  begin
    SetPath(PChar(strExeFileName));
  //设置程序文件全名
    SetArguments(PChar(strParameters));
  //设置程序的命令行参数
  //设置程序的工作目录
    SetWorkingDirectory(Pchar(ExtractFilePath(strExeFileName)));
  end;

  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL); //获得桌面的Itemidlist
  shelllinkTemp.SetDescription(Pchar(strHint));

//构造快捷方式的文件名(.LNK)
  strDesktopDirectory := strDesktopDirectory + '\' + ExtractFileName(strExeFileName);
  strDesktopDirectory := copy(strDesktopDirectory, 1, length(strDesktopDirectory) - length(ExtractFileExt(strExeFileName))) + '.LNK';

//保存快捷方式的文件
  persistfileTemp := shelllinkTemp as IPersistFile;
  if S_OK = persistfileTemp.Save(PWChar(strDesktopDirectory), false) then
    result := true //保存成功，返回True
  else
    result := false;
end;



{查找文件}
procedure SearchPath(
                     path,                              //文件路径
                     filename: string;                  //文件名
                     list: TStrings;                    //
                     status: TStatusPanel                 //
                     );
var
  sr: TSearchRec;
  iAttributes: Integer;
  function SearchFile(path, filename: string; list: TStrings): Boolean;
  var
    sr: TSearchRec;
    iAttributes: Integer;
    found: Boolean;
  begin
    iAttributes := 0;
    iAttributes := iAttributes or faHidden;
    found := False;
    if (FindFirst(path + '' + '*.*', iAttributes, sr) = 0) then
    begin
      if Pos(filename, sr.Name) <> 0 then
      begin
        list.Add(path + '' + sr.Name);
        found := True;
        Inc(FileCount);
      end;
    end;
    while (FindNext(sr) = 0) do
    begin
      if Pos(filename, sr.Name) <> 0 then
      begin
        list.Add(path + '' + sr.Name);
        found := True;
        Inc(FileCount);
      end;
    end;
    FindClose(sr);
    Result := found;
  end;
begin
  iAttributes := 0;
  iAttributes := iAttributes or faDirectory;

  SearchFile(path, filename, list);
  Sleep(1);
  status.Text := path;
  if (FindFirst(path + '*.*', iAttributes, sr) = 0) then
  begin
    if (sr.Attr = iAttributes) then
    begin
      if ((sr.Name <> '.') and (sr.Name <> '..')) then
      begin
        SearchPath(path + '' + sr.Name + '\', filename, list, status);
      end;
    end;
    while (FindNext(sr) = 0) do
    begin
//      if stopflag = 1 then
//      begin
//        exit;
//      end;
      if (sr.Attr = iAttributes) then
      begin
        if ((sr.Name <> '.') and (sr.Name <> '..')) then
          SearchPath(path + '' + sr.Name + '\', filename, list, status);
      end;
    end;
  end;
  FindClose(sr);
//  status.Text := '查找完毕';
end;

{获取电脑磁盘}
function getPath(items: TStrings): Integer;
var
  i: integer;
begin
  for i := 65 to 90 do
  begin
    if (GetDriveType(Pchar(chr(i) + ':\')) = 2) or (GetDriveType(Pchar(chr(i) + ':\')) = 3) then
      items.Add(chr(i) + ':\');
  end;
  result := 0;
end;

{ 判断文件是否正在使用 }
function IsFileInUse(
                     fName: string                                    //文件名
                     ): boolean;
var
  HFileRes: HFILE;
begin
  Result := false;
  if not FileExists(fName) then exit;
  HFileRes := CreateFile(pchar(fName), GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then CloseHandle(HFileRes);
end;

{ 创建桌面快捷方式 }
procedure CreateShortCut(const sPath: string; sShortCutName: WideString);
var
  tmpObject: IUnknown;
  tmpSLink: IShellLink;
  tmpPFile: IPersistFile;
  PIDL: PItemIDList;
  StartupDirectory: array[0..MAX_PATH] of Char;
  StartupFilename: String;
  LinkFilename: WideString;
begin
  StartupFilename := sPath;
  tmpObject := CreateComObject(CLSID_ShellLink); { 创建建立快捷方式的外壳扩展 }
  tmpSLink := tmpObject as IShellLink;           { 取得接口 }
  tmpPFile := tmpObject as IPersistFile;         { 用来储存*.lnk文件的接口 }
  tmpSLink.SetPath(pChar(StartupFilename));      { 设定notepad.exe所在路径 }
  tmpSLink.SetWorkingDirectory(pChar(ExtractFilePath(StartupFilename))); {设定工作目录 }
  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL); { 获得桌面的Itemidlist }
  SHGetPathFromIDList(PIDL, StartupDirectory);   { 获得桌面路径 }
  sShortCutName := '/' + sShortCutName + '.lnk';
  LinkFilename := StartupDirectory + sShortCutName;
  tmpPFile.Save(pWChar(LinkFilename), FALSE);    { 保存*.lnk文件 }
end;

{ 删除桌面快捷方式 }
procedure DeleteShortCut(sShortCutName: WideString);
var
  PIDL : PItemIDList;
  StartupDirectory: array[0..MAX_PATH] of Char;
  LinkFilename: WideString;
begin
  SHGetSpecialFolderLocation(0,CSIDL_DESKTOPDIRECTORY,PIDL);
  SHGetPathFromIDList(PIDL,StartupDirectory);
  LinkFilename := StrPas(StartupDirectory) + '/' + sShortCutName + '.lnk';
  DeleteFile(LinkFilename);
end;

{ 程序运行后删除自身 }
procedure DeleteSelf;
var
  hModule: THandle;
  buff:    array[0..255] of Char;
  hKernel32: THandle;
  pExitProcess, pDeleteFileA, pUnmapViewOfFile: Pointer;
begin
  hModule := GetModuleHandle(nil);
  GetModuleFileName(hModule, buff, sizeof(buff));

  CloseHandle(THandle(4));

  hKernel32        := GetModuleHandle('KERNEL32');
  pExitProcess     := GetProcAddress(hKernel32, 'ExitProcess');
  pDeleteFileA     := GetProcAddress(hKernel32, 'DeleteFileA');
  pUnmapViewOfFile := GetProcAddress(hKernel32, 'UnmapViewOfFile');

  asm
    LEA         EAX, buff
    PUSH        0
    PUSH        0
    PUSH        EAX
    PUSH        pExitProcess
    PUSH        hModule
    PUSH        pDeleteFileA
    PUSH        pUnmapViewOfFile
    RET
  end;
end;

{ 取文件的主文件名 }
function GetMainFileName(AFileName:string): string;
var
  TmpStr: string;
begin
  if AFileName = '' then Exit;
  TmpStr := ExtractFileName(AFileName);
  Result := Copy(TmpStr, 1, Pos('.', TmpStr) - 1);
end;

{ 检测允许试用的天数是否已到期 }
function CheckTrialDays(AllowDays: Integer): Boolean;
var
  Reg_ID, Pre_ID: TDateTime;
  FRegister: TRegistry;
begin
  { 初始化为试用没有到期 }
  Result := True;
  FRegister := TRegistry.Create;
  try
    with FRegister do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('Software/Microsoft/Windows/CurrentSoftware/' + GetMainFileName(Application.ExeName), True) then
      begin
        if ValueExists('DateTag') then
        begin
          Reg_ID := ReadDate('DateTag');
          if Reg_ID = 0 then
            Exit;
          Pre_ID := ReadDate('PreDate');
          { 允许使用的时间到 }
          if ((Reg_ID <> 0) and (Now - Reg_ID > AllowDays)) or (Pre_ID <> Reg_ID) or (Reg_ID > Now) then
          begin
            { 防止向前更改日期 }
            WriteDateTime('PreDate', Now + 20000);
            Result := False;
          end;
        end
        else
        begin
          { 首次运行时保存初始化数据 }
          WriteDateTime('PreDate', Now);
          WriteDateTime('DateTag', Now);
        end;
      end;
    end;
  finally
    FRegister.Free;
  end;
end;

{ 保存日志文件 }
procedure AddLogFile(
                     sInfoStr: string                   //日志内容
                     );
var
  FName: TextFile;
  AFormat: TFormatSettings;
  LogFile   : String;
begin
  if Trim(sInfoStr) = '' then
    exit;
  try
    AFormat.ShortDateFormat:='yyyymmdd';
    LogFile := ExtractFilePath(Application.ExeName) + 'Logs\' + DateToStr(Now,AFormat) + '.log';
    if not DirectoryExists(ExtractFilePath(LogFile)) then
      CreateDir(ExtractFilePath(LogFile));
    AssignFile(FName, LogFile);
    if FileExists(LogFile) then
    begin
      Append(FName);
    end
    else
    begin
      ReWrite(FName);
    end;
    sInfoStr:=DateToStr(Date())+ ' '+TimeToStr(Time()) + Chr(9) + sInfoStr + #10#13;
    WriteLn(FName,sInfoStr);
  finally
    CloseFile(FName);
  end;
end;

{ 获取文件版本号}
function GetFileVersion(
                        FileName: string                  //文件名
                        ): string;
type
  PVerInfo = ^TVS_FIXEDFILEINFO;

  TVS_FIXEDFILEINFO = record
    dwSignature: longint;
    dwStrucVersion: longint;
    dwFileVersionMS: longint;
    dwFileVersionLS: longint;
    dwFileFlagsMask: longint;
    dwFileFlags: longint;
    dwFileOS: longint;
    dwFileType: longint;
    dwFileSubtype: longint;
    dwFileDateMS: longint;
    dwFileDateLS: longint;
  end;
var
  ExeNames: array[0..255] of char;
  zKeyPath: array[0..255] of Char;
  VerInfo: PVerInfo;
  Buf: pointer;
  Sz: word;
  L, Len: Cardinal;
begin
  StrPCopy(ExeNames, FileName);
  Sz := GetFileVersionInfoSize(ExeNames, L);
  if Sz = 0 then
  begin
    Result := '';
    Exit;
  end;

  try
    GetMem(Buf, Sz);
    try
      GetFileVersionInfo(ExeNames, 0, Sz, Buf);
      if VerQueryValue(Buf, '\', Pointer(VerInfo), Len) then
      begin
        Result := IntToStr(HIWORD(VerInfo.dwFileVersionMS)) + '.' + IntToStr(LOWORD(VerInfo.dwFileVersionMS)) + '.' + IntToStr(HIWORD(VerInfo.dwFileVersionLS)) + '.' + IntToStr(LOWORD(VerInfo.dwFileVersionLS));

      end;
    finally
      FreeMem(Buf);
    end;
  except
    Result := '-1';
  end;
end;
end.
