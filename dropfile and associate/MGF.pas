unit MGF;

interface

uses Winapi.Windows,Registry,ShlObj,ActiveX,ComObj,System.SysUtils,Winapi.ShellAPI,
     Winapi.Messages,Vcl.Forms,System.Classes;


{1�����ÿ�������}
function AutoPowerOnSet(var
                        exename,                        //�������� application.name
                        desc:string                     //��������
                        ): Integer;
{2���رտ�������}
function AutoPowerOnDelete(var
                        exename,                     //�������� application.name
                        desc:string                     //��������
                        ): Integer;

{3������Ӧ�ó���}
function SetAssociatedExec(var
                           FileExt,                     //�����׺����.exe��
                           Filetype,                    //�ļ����ͣ�ע�����أ�
                           FileDescription,             //�ļ�����
                           MIMEType,
                           ExecName,                    //������  Application.ExeName
                           IcoName: string              //ͼ���ַ
                           ): Boolean;                  {�޸ĳɹ�,����True,����False}

{4�����������ݷ�ʽ}
function CreateShortcutOnDesktop(var
                                 strExeFileName,        // ��ݳ�����  Application.ExeName
                                 strParameters,         // ���в���
                                 strHint: string        // ��ʾ����������Ƶ��������ʾ��
                                 ): boolean;

implementation

{���ÿ�������}
function AutoPowerOnSet(var
                        exename,                        //��������
                        desc:string                     //��������
                        ): Integer;
var
  reg: TRegistry; //����һ��TRegistry�����
begin
    reg := Tregistry.create;
    reg.rootkey := HKEY_LOCAL_MACHINE;
    if reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true) then
    begin
      if not reg.keyexists(exename) then //if not exist ,add it!
        reg.writestring('delphi test', exename);
      reg.CloseKey; //�ر�ע���
    end;
    reg.Free; //�ͷű�����ռ�ڴ�
end;

{�رտ�������}
function AutoPowerOnDelete(var
                           exename,                        //��������
                           desc:string                     //��������
                           ): Integer;
var
  reg: TRegistry; //����һ��TRegistry�����
begin
  begin
    reg := Tregistry.create;
    reg.rootkey := HKEY_LOCAL_MACHINE;
    if reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true) then
    begin
//    if reg.keyexists(Application.ExeName) then //if not exist ,add it!
      reg.DeleteValue('delphi test');
      reg.CloseKey; //�ر�ע���
    end;
    reg.Free; //�ͷű�����ռ�ڴ�
  end;
end;

{����Ӧ�ó���}
function SetAssociatedExec(var
                           FileExt,                     //�����׺����.exe��
                           Filetype,                    //�ļ����ͣ�ע�����أ�
                           FileDescription,             //�ļ�����
                           MIMEType,
                           ExecName,                    //������  Application.ExeName
                           IcoName: string              //ͼ���ַ
                           ): Boolean;                  {�޸ĳɹ�,����True,����False}
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
 //SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_IDLIST,nil,nil);  //ˢ����ʾ
  end;
end;

{���������ݷ�ʽ}
function CreateShortcutOnDesktop(var
                                 strExeFileName,        // ��ݳ�����  Application.ExeName
                                 strParameters,         // ���в���
                                 strHint: string        // ��ʾ����������Ƶ��������ʾ��
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
//����һ��Registryʵ��
  with registerTemp do
  begin
    RootKey := HKEY_CURRENT_USER;
//���ø���ֵΪHKEY_CURRENT_USER
//�ҵ�Software\MicroSoft\Windows\CurrentVersion\Explorer\Shell Folders
    if not OpenKey('Software\MicroSoft\Windows\CurrentVersion\Explorer\Shell Folders', True) then
//д���Լ��������Ϣ
    begin
      result := false;
      exit;
    end;
//��ȡ��ĿDesktop��ֵ����Desktop��ʵ��·��
    strDesktopDirectory := ReadString('Desktop');
//�ƺ���
    CloseKey;
    Free;
  end;

//���ÿ�ݷ�ʽ�Ĳ���
  shelllinkTemp := CreateComObject(CLSID_ShellLink) as IShellLink;
  with shelllinkTemp do
  begin
    SetPath(PChar(strExeFileName));
  //���ó����ļ�ȫ��
    SetArguments(PChar(strParameters));
  //���ó���������в���
  //���ó���Ĺ���Ŀ¼
    SetWorkingDirectory(Pchar(ExtractFilePath(strExeFileName)));
  end;

  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL); //��������Itemidlist
  shelllinkTemp.SetDescription(Pchar(strHint));

//�����ݷ�ʽ���ļ���(.LNK)
  strDesktopDirectory := strDesktopDirectory + '\' + ExtractFileName(strExeFileName);
  strDesktopDirectory := copy(strDesktopDirectory, 1, length(strDesktopDirectory) - length(ExtractFileExt(strExeFileName))) + '.LNK';

//�����ݷ�ʽ���ļ�
  persistfileTemp := shelllinkTemp as IPersistFile;
  if S_OK = persistfileTemp.Save(PWChar(strDesktopDirectory), false) then
    result := true //����ɹ�������True
  else
    result := false;
end;





end.