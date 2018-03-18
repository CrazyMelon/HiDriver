unit MGF;

interface

uses Winapi.Windows,Registry,ShlObj,ActiveX,ComObj,System.SysUtils,Winapi.ShellAPI,
     Winapi.Messages,Vcl.Forms,System.Classes;


{1、设置开机启动}
function AutoPowerOnSet(var
                        exename,                        //程序名字 application.name
                        desc:string                     //程序描述
                        ): Integer;
{2、关闭开机启动}
function AutoPowerOnDelete(var
                        exename,                     //程序名字 application.name
                        desc:string                     //程序描述
                        ): Integer;

{3、关联应用程序}
function SetAssociatedExec(var
                           FileExt,                     //程序后缀（如.exe）
                           Filetype,                    //文件类型（注册表相关）
                           FileDescription,             //文件描述
                           MIMEType,
                           ExecName,                    //程序名  Application.ExeName
                           IcoName: string              //图标地址
                           ): Boolean;                  {修改成功,返回True,否则False}

{4、创建桌面快捷方式}
function CreateShortcutOnDesktop(var
                                 strExeFileName,        // 快捷程序名  Application.ExeName
                                 strParameters,         // 运行参数
                                 strHint: string        // 提示描述（鼠标移到上面的提示）
                                 ): boolean;

implementation

{设置开机启动}
function AutoPowerOnSet(var
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
function AutoPowerOnDelete(var
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
function SetAssociatedExec(var
                           FileExt,                     //程序后缀（如.exe）
                           Filetype,                    //文件类型（注册表相关）
                           FileDescription,             //文件描述
                           MIMEType,
                           ExecName,                    //程序名  Application.ExeName
                           IcoName: string              //图标地址
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
      if MIMEType <> '' then
      WriteString('Content Type', MIMEType);
      CloseKey;
      if not OpenKey(FileType, True) then Exit;
      WriteString('', FileDescription);
      CloseKey;
      if not OpenKey(FileType + '\' + 'shell\open\command', True) then  Exit;
      WriteString('', '"' + ParamStr(0) + '"%1');
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
function CreateShortcutOnDesktop(var
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





end.
