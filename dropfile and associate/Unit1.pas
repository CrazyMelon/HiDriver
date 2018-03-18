unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  IniFiles, Registry, ShlObj, ActiveX, ComObj, ShellAPI, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ExtCtrls, Vcl.ImgList, System.ImageList;
//type
//  TMyMenuItem = class(TMenuItem)
//  procedure popmenu(Sender: TObject);
//end;

//---------------------��ʼ��Delphi 7�����Ӵ�����-------------------------------

const
  NIF_INFO = $00000010;          //������ʾ��־
  NIIF_NONE = $00000000;          //��ͼ��
  NIIF_INFO = $00000001;          //��Ϣͼ��
  NIIF_WARNING = $00000002;          //����ͼ��
  NIIF_ERROR = $00000003;          //����ͼ��
  NIIF_USER = $00000004;          //XPʹ��hIconͼ��

type
  TNotifyIconDataEx = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of Char;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of Char;
    case Integer of
      0:
        (uTimeout: UINT);
      1:
        (uVersion: UINT;
        szInfoTitle: array[0..63] of Char;
        dwInfoFlags: DWORD);
  end;

const
  WM_TRAYMSG = WM_USER + 101;                   //�Զ���������Ϣ

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Exit1: TMenuItem;
    N2: TMenuItem;
    PopupMenu1: TPopupMenu;
    Delete1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    One1: TMenuItem;
    two1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    SaveDialog1: TSaveDialog;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Find1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Reference1: TMenuItem;
    N3: TMenuItem;
    Reopen1: TMenuItem;
    Clearhistory1: TMenuItem;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    Project1: TMenuItem;
    Newproject1: TMenuItem;
    Openproject1: TMenuItem;
    ImageList2: TImageList;
    About1: TMenuItem;
    Help1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Delete1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure One1Click(Sender: TObject);
    procedure two1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure Open1AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
    procedure N1AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
    procedure N3Click(Sender: TObject);
    procedure Clearhistory1Click(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
//    procedure sysmenu(var msg:TWMMenuSelect);message wm_syscommand;
    procedure MyFileClick(Sender: TObject);
    procedure WMTrayMsg(var Msg: TMessage); message WM_TRAYMSG;    //����������Ϣ
    procedure WMSysCommand(var Msg: TMessage); message WM_SYSCOMMAND;
    procedure dropFiles(var Msg: TMessage); message WM_DROPFILES;
//    function trans(str: string):PAnsiChar;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  myinifile: Tinifile;
  NotifyIcon: TNotifyIconDataEx;                    //��������ͼ��ṹ��
  Mbitmap: Tbitmap;

function AssignToProgram(strFileExtension, strDiscription, strExeFileName: string): boolean;

implementation

{$R *.dfm}

procedure TForm1.MyFileClick(Sender: TObject);
var
  str: string;
  id: Integer;
  QQ: TMenuItem;
begin
  str := TMenuItem(Sender).Caption;
  if Sender is TMenuItem then
  begin
    if FileExists(str) then
    begin
      QQ := TMenuItem.Create(nil);
      QQ.Caption := str;
      id := MainMenu1.Items.Items[0].Items[2].IndexOf(TMenuItem(Sender));
      MainMenu1.Items.Items[0].Items[2].Delete(id);

      Memo1.Lines.LoadFromFile(str);
      MainMenu1.Items.Items[0].Items[2].Insert(0, QQ);
      QQ.OnClick := MyFileClick;
      Form1.Caption := QQ.Caption;
    end
    else
    begin
      id := MainMenu1.Items.Items[0].Items[2].IndexOf(TMenuItem(Sender));
      MainMenu1.Items.Items[0].Items[2].Delete(id);
      ShowMessage('File not found');
    end;
  end;
//   try
//    Memo1.Lines.LoadFromFile(str);
//   except
//    MainMenu1.Items.Delete(MainMenu1.Items.IndexOf(TMenuItem(Sender)));
//   end;
  //Memo1.
end;

procedure TForm1.N1AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
var
  Mrect: Trect;
begin
//  acanvas.TextWidth(TMenuItem(Sender).Caption);
//  mrect:= rect(0,0,mbitmap.Width,mbitmap.Height);
//  acanvas.Draw(arect.Left,arect.Top-arect.Bottom,mbitmap);
//  acanvas.TextRect(rect(arect.Left+mbitmap.Width+2,arect.Top,arect.Right,arect.Bottom),arect.Left+mbitmap.Width+2,arect.Top+3,TMenuItem(Sender).Caption);
//  setbkmode(acanvas.Handle,TRANSPARENT);
//  DrawText(acanvas.Handle,'��'+#13+'��'+#13+'��'+#13+'��',-1,mrect,DT_LEFT+DT_Center);
end;

procedure TForm1.N3Click(Sender: TObject);
var
  reg: TRegistry; //����һ��TRegistry�����
begin
  N3.Checked := not N3.Checked;
  if N3.Checked then
  begin
       {��������}
    reg := Tregistry.create;
    reg.rootkey := HKEY_LOCAL_MACHINE;
    if reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true) then
    begin
      if not reg.keyexists(Application.ExeName) then //if not exist ,add it!
        reg.writestring('delphi test', Application.ExeName);
      reg.CloseKey; //�ر�ע���
    end;
    reg.Free; //�ͷű�����ռ�ڴ�
  end
  else
  begin
    reg := Tregistry.create;
    reg.rootkey := HKEY_LOCAL_MACHINE;
    if reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true) then
    begin
//      if reg.keyexists(Application.ExeName) then //if not exist ,add it!
      reg.DeleteValue('delphi test');
      reg.CloseKey; //�ر�ע���
    end;
    reg.Free; //�ͷű�����ռ�ڴ�
  end;

end;

procedure TForm1.Delete1Click(Sender: TObject);
var
  str: string;
begin
//  str := TMenuItem(Sender).Items[0];
  MainMenu1.Items.Delete(MainMenu1.Items.IndexOf(TMenuItem(Sender)));
end;

procedure TForm1.Exit1Click(Sender: TObject);
var
  i: Integer;
begin
//  for I := 0 to MainMenu1.items.Items[0].Count-3 do
//  begin
//    MainMenu1.Items.items[0].Items[i].OnClick := MainMenu1.Items.items[0].Items[2].OnClick ;
//  end;
  Self.close;

end;

var
  de: string = 'ValStr';
{��ʷ��¼}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  desname: string;
  glAppPath: string;
  i: Integer;
  reg: TRegistry; //����һ��TRegistry�����
begin
    {����1 ini�ļ�}
  glAppPath := ExtractFilePath(Application.ExeName); //��ȡ��ǰ���г����·��
  myinifile := Tinifile.Create(glAppPath + 'myini.ini');
  try
    for i := MainMenu1.Items.items[0].Items[2].Count - 1 downto 0 do
    begin
      desname := de + IntToStr(i);
      myinifile.WriteString('MySection', desname, MainMenu1.Items.items[0].Items[2].Items[i].Caption);
    end;

  finally
    myinifile.Free;
  end;

    {����2 ע���}
  reg := TRegistry.Create; //����ʵ��
  reg.RootKey := HKEY_CURRENT_USER; //ָ����Ҫ������ע���������
  if reg.OpenKey('\Software\Delphi', true) then//����򿪳ɹ���������²���
  begin
    for i := MainMenu1.Items.items[0].Items[2].Count - 2 downto 0 do
    begin
      desname := de + IntToStr(i);
      reg.WriteString(desname, MainMenu1.Items.items[0].Items[2].Items[i].Caption); //����Ҫ�������Ϣд��ע���
    end;
    reg.CloseKey; //�ر�ע���
  end;
  reg.Free; //�ͷű�����ռ�ڴ�

  shell_notifyicona(NIM_DELETE, @NotifyIcon);

end;

//function TForm1.trans(str: string):PAnsiChar;
//var
//// Str:string;
// SN: Array [0..7] of AnsiChar;
// I:Integer;
//begin
////  Str := '66778899';
//  for I := 0 to Length(Str) - 1 do
//  begin
//    SN[I] := AnsiChar(Str[I+1]);
//  end;
//end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  Filename: string;
  glAppPath: string;
  QQ: TMenuItem;
  desname: string;
  reg: TRegistry; //����һ��TRegistry�����
  strFileName: string;
//  p:PAnsiChar;
//  pp:TPopupMenu;
begin
  Memo1.Clear;
  with NotifyIcon do
  begin
    cbSize := SizeOf(TNotifyIconDataEx);
    Wnd := Self.Handle;
    uID := 1;
    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP + NIF_INFO;   //ͼ�ꡢ��Ϣ����ʾ��Ϣ
    uCallbackMessage := WM_TRAYMSG;
    hIcon := Application.Icon.Handle;
    szTip := 'MY';
    szInfo := 'hint';
    szInfoTitle := '��ʾ��Ϣ��';
    dwInfoFlags := NIIF_USER;
  end;
//    with NotifyIcon do
//  begin
//    cbSize := SizeOf(TNotifyIconData);
//    Wnd := Self.Handle;
//    uID := 1;
//    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;   //ͼ�ꡢ��Ϣ����ʾ��Ϣ
//    uCallbackMessage := WM_TRAYMSG;
//    hIcon := Application.Icon.Handle;
//    szTip := '���̲���';
//  end;

  Shell_NotifyIcon(NIM_ADD, @NotifyIcon);

  i := GetSystemMenu(Handle, false);
  AppendMenu(i, MF_SEPARATOR, 0, nil);
  AppendMenu(i, MF_STRING, 100, '�ҵĲ˵�(&E)');


{����1 ini�ļ�}
//  glAppPath := ExtractFilePath(Application.ExeName);//��ȡ��ǰ���г����·��
//  myinifile := Tinifile.Create(glAppPath + 'myini.ini');
//
//  for I := 2 to 100 do
//  begin
//    desname := de + IntToStr(i);
//    Filename := myinifile.ReadString('MySection',desname,'');
//    if Filename = '' then
//      Break;
//
//    QQ:= TMenuItem.Create(nil);
//    QQ.Caption:= Filename ;
//    MainMenu1.Items.Items[0].Insert(i,QQ);
//    QQ.OnClick := MyFileClick;
//  end;
//
//  myinifile.Free;

{����2 ע���}
  reg := TRegistry.Create; //����ʵ��
  reg.RootKey := HKEY_CURRENT_USER; //ָ����Ҫ������ע���������
  if reg.OpenKey('\Software\Delphi', true) then//����򿪳ɹ���������²���
  begin
    for i := 0 to 10 do
    begin
      desname := de + IntToStr(i);
      Filename := reg.ReadString(desname); //����Ҫ�������Ϣд��ע���
      if Filename = '' then
        Break;
      QQ := TMenuItem.Create(nil);
      QQ.Caption := Filename;
      MainMenu1.Items.Items[0].Items[2].Insert(i, QQ);
      QQ.OnClick := MyFileClick;
    end;
    reg.CloseKey; //�ر�ע���
  end;
  reg.Free; //�ͷű�����ռ�ڴ�


  strFileName := '';
  for i := 1 to ParamCount do
    strFileName := strFileName + ' ' + ParamStr(i);
  strFileName := ParamStr(1);

  strFileName := Trim(strFileName);
//  //���Լ��Ĵ������Play(strFileName)
    ShowMessage(ParamCount.ToString());
    ShowMessage(ParamStr(2));

  if strFileName <> '' then
  begin

    QQ := TMenuItem.Create(nil);
    for i := 1 to MainMenu1.Items.Items[0].Items[2].Count - 1 do
    begin
      if MainMenu1.Items.Items[0].Items[2].Items[i].Caption = strFileName then
      begin
        MainMenu1.Items.Items[0].Items[2].Delete(i);
        Break;
      end;
    end;
    QQ.Caption := strFileName;
    MainMenu1.Items.Items[0].Items[2].Insert(0, QQ);
    Memo1.Lines.LoadFromFile(strFileName);
    QQ.OnClick := MyFileClick;
  end;

  DragAcceptFiles(Handle, True); //�ڶ�������ΪFalseʱ���������ļ��Ϸ�

 // { UACȨ�� ʹ�������У�
  ChangeWindowMessageFilter(WM_DROPFILES, MSGFLT_ADD);

  ChangeWindowMessageFilter(WM_COPYDATA, MSGFLT_ADD);

  ChangeWindowMessageFilter(WM_COPYGLOBALDATA, MSGFLT_ADD);


//  Mbitmap:=Tbitmap.Create;
//  mbitmap.LoadFromFile('2.bmp');

  reg := Tregistry.create;
  reg.rootkey := HKEY_LOCAL_MACHINE;
  if reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true) then
  begin
    if reg.ValueExists('delphi test') then //if not exist ,add it!
//        reg.DeleteValue('delphi test');
      N3.Checked := True
    else
      N3.Checked := False;
    reg.CloseKey; //�ر�ע���
  end;
  reg.Free; //�ͷű�����ռ�ڴ�

end;

procedure TForm1.One1Click(Sender: TObject);
begin
  SetForegroundWindow(Self.Handle);
  WindowState := TWindowState(tag);
  form1.Visible := True;
end;

procedure TForm1.Open1AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
var
  Mrect: Trect;
begin
//  acanvas.TextWidth(TMenuItem(Sender).Caption);
//  mrect:= rect(0,0,mbitmap.Width,mbitmap.Height);
//  acanvas.Draw(arect.Left,arect.Top-arect.Bottom,mbitmap);
//  acanvas.TextRect(rect(arect.Left+mbitmap.Width+2,arect.Top,arect.Right,arect.Bottom),arect.Left+mbitmap.Width+2,arect.Top+3,TMenuItem(Sender).Caption);
//  setbkmode(acanvas.Handle,TRANSPARENT);
//  DrawText(acanvas.Handle,'��'+#13+'��'+#13+'��'+#13+'��',-1,mrect,DT_LEFT+DT_Center);
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  QQ: TMenuItem;
  ValStr: string;   //�ַ���ֵ
  i: Integer;
//  i:Integer;
//  event: TNotifyEvent;
begin
  QQ := TMenuItem.Create(nil);
  if OpenDialog1.Execute() then
  begin
    for i := 0 to MainMenu1.Items.Items[0].Items[2].Count - 1 do
    begin
      if MainMenu1.Items.Items[0].Items[2].Items[i].Caption = OpenDialog1.FileName then
      begin
        MainMenu1.Items.Items[0].Items[2].Delete(i);
        break;
      end;
    end;

    QQ.Caption := OpenDialog1.FileName;
    MainMenu1.Items.Items[0].Items[2].Insert(0, QQ);
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    Form1.Caption := QQ.Caption;
    QQ.OnClick := MyFileClick;

//    ValStr := OpenDialog1.FileName;
//    try
//      myinifile.WriteString('MySection' ,'ValStr' ,ValStr);
//    finally
//      myinifile.Free;
//    end;
//    for I := 2 to MainMenu1.items.Items[0].Count-3 do
//    begin
//      MainMenu1.Items.items[0].Items[i].OnClick := MyFileClick ;
//    end;
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  ADate: TDateTime;
  ss: string;
  Days: array[1..7] of string;
begin
  Days[1] := '������';
  Days[2] := '����һ';
  Days[3] := '���ڶ�';
  Days[4] := '������';
  Days[5] := '������';
  Days[6] := '������';
  Days[7] := '������';
  ADate := strtodate(FormatDateTime('yyyy/mm/dd', date));
  ss := FormatDateTime('yyyy"��"m"��"d"��"hh:nn:ss', now);
  StatusBar1.Panels[0].Text := '��ǰʱ��:' + ss + #32 + Days[DayOfWeek(ADate)] + '    ';
  StatusBar1.Panels[0].Alignment := taRightJustify;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
var
  s: string;
begin
  SaveDialog1.Filter := '*.aaf|*.aaf'; //'�ı��ļ�(*.txt)|*.txt| *.gif|*.gif';
  SaveDialog1.DefaultExt := 'aaf';
  SaveDialog1.FilterIndex := 1;

// //  SaveDialog1.Execute();
  if SaveDialog1.Execute() then
  begin
 //     s:=   ExtractFileExt(SaveDialog1.FileName);
    if SaveDialog1.FilterIndex = 1 then
    begin
      SaveDialog1.DefaultExt := 'aaf';
      Memo1.lines.SaveToFile(SaveDialog1.FileName);
    end
    else
    begin
      SaveDialog1.DefaultExt := 'gif';
      Memo1.lines.SaveToFile(SaveDialog1.FileName);
    end;

  end;

end;

procedure TForm1.two1Click(Sender: TObject);
begin
  shell_notifyicona(NIM_DELETE, @NotifyIcon);
  Application.Terminate;
end;

//procedure TForm1.WMSysCommand(var msg:TWMMenuSelect);
//begin
////  if msg.IDItem = 100 then
////  begin
////    ShowMessage('checked');
////  end
////  else
////  begin
////    inherited;
////  end;
//
//   if Msg.WParam = SC_ICON then
//    Self.Visible := False
//  else
//    DefWindowProc(Self.Handle,Msg.Msg,Msg.WParam,Msg.LParam);
//
//end;


{���ļ�����strFileExtension�����
strExeFileName�����,strDiscriptionΪ�ļ�����˵�� }
function AssignToProgram(strFileExtension, strDiscription, strExeFileName: string): boolean;
var
  registerTemp: TRegistry;
begin
  registerTemp := TRegistry.Create;
  //����һ��Registryʵ��
  with registerTemp do
  begin
    RootKey := HKEY_CLASSES_ROOT;
    //���ø���ֵΪHKEY_CLASSES_ROOT
    //�����ļ����͵���չ����������򿪶�Ӧ�ļ���.FileExt,��DBF��Ӧ'.DBF'
    if not OpenKey('.' + strFileExtension, true) then
    begin
      result := false;
      exit;
    end;
//���ü�.FileExtĬ��ֵΪFileExt_Auto_File,��'.DBF'��Ӧ'DBF_Auto_File'
    WriteString('', strFileExtension + '_Auto_File');
    CloseKey;
//д���Լ��������Ϣ
//�����ļ����͵���չ����������򿪶�Ӧ�ļ���
 //   FileExt_Auto_File
//'.DBF'��Ӧ'DBF_Auto_File'
    if not OpenKey('.' + strFileExtension + '\' + strFileExtension + '_Auto_File', true) then
    begin
      result := false;
      exit;
    end;
    //����Ĭ��ֵ�ļ�����˵��,��DBF�ɶ�Ӧ'xBase���ݱ�'
    WriteString('', strDiscription);
    CloseKey;
//������򿪼���FileExt_Auto_File\Shell\open\command,�ü�Ϊ��ʾ����Ϊ'��'
//'.DBF'��Ӧ'DBF_Auto_File\shell\open\command'
    if not OpenKey('.' + strFileExtension + '\' + strFileExtension + '_Auto_File\shell\open\command', true) then
    begin
      result := false;
      exit;
    end;
//���øü���Ĭ��ֵΪ�򿪲�����Ӧ�ĳ�����Ϣ
//��DBF�ɶ�Ӧ'C:\Program Files\Borland\DBD\DBD32.EXE'
    WriteString('', strExeFileName + ' %1');
    CloseKey;
    Free;
  end;
end;

function SetAssociatedExec(FileExt, Filetype, FileDescription, MIMEType, ExecName: string): Boolean;{�޸ĳɹ�,����True,����False}
var
  Reg: TRegistry;
begin
  Result := False; {}
  if (FileExt = '') or (ExecName = '') then
    Exit; {���ļ�����Ϊ�ջ���û�?br> ����ִ�г�����˳�,FileExt�����".",��.BMP}
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKey_Classes_Root;
    if not Reg.OpenKey(FileExt, True) then
      Exit;
    Reg.WriteString('', Filetype);
    if MIMEType <> '' then
      Reg.WriteString('Content Type', MIMEType);
    Reg.CloseKey;
    if not Reg.OpenKey(Filetype, True) then
      Exit;
    Reg.WriteString('', FileDescription);
    Reg.CloseKey;
    if not Reg.OpenKey(Filetype + '\' + 'shell\open\command', True) then
      Exit;
    Reg.WriteString('', '"' + ParamStr(0) + '"%1');
    ;
    Reg.CloseKey;
    Reg.OpenKey(Filetype + '\' + '\DefaultIcon', True);
 // reg.WriteString('','C:\Users\Administrator\Desktop\cxtbsc32_veryhuo.com\ico'+',1');   //Ϊ0��ΪLetterA.icoͼ�꣬Ϊ1ΪLetterB.ico
  //reg.WriteString('','"' + ParamStr(0) + '",1');
    Reg.WriteString('', 'F:\Delphi MyWork\file_new\Win32\Debug\ooopic_1458924531.ico');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
 //SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_IDLIST,nil,nil);  //ˢ����ʾ
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  memo1.lines.add('��ʼ');
  if SetAssociatedExec('.aaf', 'aafile', '����', '', Application.ExeName) then
    memo1.lines.add('�ɹ�')
  else
    memo1.lines.add('ʧ��')
end;
//var
//  reg: TRegistry;
//begin
//  reg := TRegistry.Create;
//  try
//    reg.RootKey := HKEY_CLASSES_ROOT;
//    reg.OpenKey('.aaf',True);
//    reg.WriteString('','aafFile');
//    reg.CloseKey;
//    reg.OpenKey('aafFile\shell\open\command',True);
//    reg.WriteString('',ParamStr(0));  //������·����Ϊ��������
//    reg.CloseKey;
//    reg.OpenKey('aafFile\DefaultIcon',True);
//    reg.WriteString('','"' + ParamStr(0) + '",1');   //Ϊ0��ΪLetterA.icoͼ�꣬Ϊ1ΪLetterB.ico
//    reg.CloseKey;
//  finally
//    reg.Free;
//  end;
// // SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_IDLIST,nil,nil);  //ˢ����ʾ
//end;

function CreateShortcutOnDesktop(strExeFileName, strParameters: string): boolean;
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
  shelllinkTemp.SetDescription('�ҵĳ��������');

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

{����CreateShortcutOnDesktop,ΪDelphi�������Ͻ�����ݷ�ʽ }
procedure TForm1.Button2Click(Sender: TObject);
var
  tmpObject: IUnknown;
  tmpSLink: IShellLink;
  tmpPFile: IPersistFile;
  PIDL: PItemIDList;
  StartupDirectory: array[0..MAX_PATH] of Char;
  StartupFilename: string;
  LinkFilename: WideString;
begin
////������ݷ�ʽ������
//StartupFilename :=Application.ExeName;
//tmpObject := CreateComObject(CLSID_ShellLink);//����������ݷ�ʽ�������չ
//tmpSLink := tmpObject as IShellLink;//ȡ�ýӿ�
//tmpPFile := tmpObject as IPersistFile;//��������*.lnk�ļ��Ľӿ�
//tmpSLink.SetPath(pChar(StartupFilename));//�趨����·��
//tmpSLink.SetWorkingDirectory(pChar(ExtractFilePath(StartupFilename)));//�趨����Ŀ¼
//SHGetSpecialFolderLocation(0,CSIDL_DESKTOPDIRECTORY,PIDL);//��������Itemidlist
//tmpSLink.SetDescription('�ҵĳ��������');
//tmpSLink.SetIconLocation(Pchar(StartupFilename),3);
//SHGetPathFromIDList(PIDL,StartupDirectory);//�������·��
//LinkFilename := StartupDirectory + '\�ҵĳ���.lnk';
//tmpPFile.Save(pWChar(LinkFilename),FALSE);//����*.lnk�ļ�

  CreateShortcutOnDesktop('F:\Delphi MyWork\file_new\Win32\Debug\Project2.exe', '');
end;

procedure TForm1.Clearhistory1Click(Sender: TObject);
var
  i: Integer;
  reg: TRegistry;
  desname: string;
  Filename: string;
begin
  for i := MainMenu1.Items.Items[0].Items[2].Count - 2 downto 0 do
  begin
    MainMenu1.Items.Items[0].Items[2].Delete(i);
  end;

  reg := TRegistry.Create; //����ʵ��
  reg.RootKey := HKEY_CURRENT_USER; //ָ����Ҫ������ע���������
  if reg.OpenKey('\Software\Delphi', true) then//����򿪳ɹ���������²���
  begin
    for i := 0 to 10 do
    begin
      desname := de + IntToStr(i);
      Filename := reg.ReadString(desname); //����Ҫ�������Ϣд��ע���
      if Filename = '' then
        Break;
      reg.DeleteValue(desname);
    end;
    reg.CloseKey; //�ر�ע���
  end;
  reg.Free; //�ͷű�����ռ�ڴ�

end;

{-------------------------------------------------------------------------------
 Description: ��������ʱ��ж������
-------------------------------------------------------------------------------}
procedure TForm1.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon);
end;
{-------------------------------------------------------------------------------
 Description: �ػ�����С����Ϣ����С��������
-------------------------------------------------------------------------------}

procedure TForm1.WMSysCommand(var Msg: TMessage);
begin
  if Msg.WParam = SC_ICON then
    Self.Visible := False
  else
    DefWindowProc(Self.Handle, Msg.Msg, Msg.WParam, Msg.LParam);

  if TWMMenuSelect(Msg).IDItem = 100 then
  begin
    ShowMessage('checked');
  end
  else
  begin
    inherited;
  end;
end;
{-------------------------------------------------------------------------------
 Description: �Զ����������Ϣ
-------------------------------------------------------------------------------}

procedure TForm1.WMTrayMsg(var Msg: TMessage);
var
  p: TPoint;
begin
  case Msg.LParam of
    WM_LBUTTONDOWN:
      begin
        SetForegroundWindow(Self.Handle);
//         ShowWindow(Self.Handle, SW_SHOW);
        WindowState := TWindowState(tag);
        Visible := not Visible;   //��ʾ����
      end;
    WM_RBUTTONDOWN:
      begin
        SetForegroundWindow(Self.Handle);   //�Ѵ�����ǰ
        GetCursorPos(p);
        PopupMenu2.Popup(p.X, p.Y);
      end;
  end;

end;

{�ļ��϶�}
procedure TForm1.DropFiles(var Msg: TMessage);
var
  buffer: array[0..1024] of Char;
  buf: string;
  i, Res: Integer;
  Node: TTreeNode;
  QQ: TMenuItem;
begin
  inherited;
  buffer[0] := #0;
  DragQueryFile(Msg.WParam, 0, buffer, sizeof(buffer)); //��һ���ļ�

  memo1.Lines.LoadFromFile(buffer);

  QQ := TMenuItem.Create(nil);
  for i := 0 to MainMenu1.Items.Items[0].Items[2].Count - 1 do
  begin
    if MainMenu1.Items.Items[0].Items[2].Items[i].Caption = buffer then
    begin
      MainMenu1.Items.Items[0].Items[2].Delete(i);
      Break;
    end;
  end;
  QQ.Caption := buffer;
  MainMenu1.Items.Items[0].Items[2].Insert(0, QQ);
  Memo1.Lines.LoadFromFile(buffer);
  Form1.Caption := QQ.Caption;
  QQ.OnClick := MyFileClick;

end;

end.
