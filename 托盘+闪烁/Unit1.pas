unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, AppEvnts, StdCtrls, Menus, Vcl.ExtCtrls;

const
  WM_NID = WM_User + 1000; //声明一个常量

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

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Timer1: TTimer;
    Button1: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

    { Private declarations } // 定义两个函数

    procedure SysCommand(var SysMsg: TMessage); message WM_SYSCOMMAND;
    procedure WMNID(var msg: TMessage); message WM_NID;
  public
  end;

var
  Form1: TForm1;
  NotifyIcon, NotifyIcon1, NotifyIcon2: TNotifyIconDataEx; // 全局变量
  IconBlink: BOOL;
  Timer1Cnt: Integer;
  NilIcon: Ticon;

implementation

{$R *.dfm}

var
  myform: TForm;

procedure TForm1.WMNID(var msg: TMessage);
var
  mousepos: TPoint;
begin

  GetCursorPos(mousepos); //获取鼠标位置

  case msg.LParam of

    WM_LBUTTONUP: // 在托盘区点击左键后

      begin

        Form1.Visible := not Form1.Visible; // 显示主窗体与否

        SetWindowPos(Application.Handle, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW); // 在任务栏显示程序

      end;

    WM_RBUTTONUP:

      PopupMenu1.Popup(mousepos.X, mousepos.Y); // 弹出菜单

  end;

//  if myform = nil then
//  begin
//    myform := TForm.Create(nil);
//  end;
//  myform.Show;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  IconBlink := not IconBlink;

  if IconBlink then
    Timer1.Enabled := True
  else
  begin
    NotifyIcon1.hIcon := Application.Icon.Handle;
    Shell_NotifyIcon(NIM_MODIFY, @NotifyIcon1); //
    Timer1.Enabled := False;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  trayhint: string;
  traymessage: string;
begin

  IconBlink := False;

  Timer1Cnt := 0;

  Timer1.Enabled:=False;

  NilIcon := TIcon.Create;

  trayhint := '账号"' + '"登陆成功！';

  traymessage := 'HiTools' + #13#10 + '账号：';

  with NotifyIcon do
  begin
    cbSize := SizeOf(TNotifyIconDataEx);
    Wnd := Self.Handle;
    uID := 1;
    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP + NIF_INFO;   //图标、消息、提示信息
    uCallbackMessage := WM_NID;
    hIcon := Application.Icon.Handle;
    szTip := '';
    CopyMemory(@szTip[0], PChar(traymessage), ByteLength(traymessage));
 //   szTip := 'HiTools';

    szInfo := '';
    CopyMemory(@szInfo[0], PChar(trayhint), ByteLength(trayhint));
//    szInfo :=  trayhint;
    szInfoTitle := '提示信息！';
    dwInfoFlags := NIIF_USER;
  end;

  Shell_NotifyIcon(NIM_ADD, @NotifyIcon);

  with NotifyIcon1 do

  begin

    cbSize := SizeOf(TNotifyIconDataEx);

    Wnd := Handle;

    uID := 1;

    hIcon := Application.Icon.Handle;

    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP + NIF_INFO;

    uCallBackMessage := WM_NID;

    dwInfoFlags := NIIF_USER;

    szTip := '';
    CopyMemory(@szTip[0], PChar(traymessage), ByteLength(traymessage));

  end;

  FormStyle := fsStayOnTop;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon1); // 删除托盘图标

end;

procedure TForm1.SysCommand(var SysMsg: TMessage);
begin

  case SysMsg.WParam of

    SC_MINIMIZE: // 当最小化时

      begin

        SetWindowPos(Application.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_HIDEWINDOW);

        Hide; // 在任务栏隐藏程序

        Shell_NotifyIcon(NIM_MODIFY, @NotifyIcon); // 在托盘区显示图标

      end;

  else

    inherited;

  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Inc(Timer1Cnt);

  if (Timer1Cnt mod 2) = 1 then
  begin
    NotifyIcon1.hIcon := NilIcon.Handle;
  end
  else
  begin
    NotifyIcon1.hIcon := Application.Icon.Handle;
  end;
  Shell_NotifyIcon(NIM_MODIFY, @NotifyIcon1); // 在托盘区显示图标

end;

{以下三个函数为托盘右键菜单，可自行添加功能}

procedure TForm1.N1Click(Sender: TObject);
begin

  ShowMessage('Delphi托盘小程序！');

end;

procedure TForm1.N2Click(Sender: TObject);
begin

  Form1.Visible := true; // 显示窗体

  SetWindowPos(Application.Handle, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW);

  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon); // 删除托盘图标

end;

procedure TForm1.N3Click(Sender: TObject);
begin

  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon);

  Application.Terminate;

end;

end.

