unit Unit1;
//test messageS1111
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Winapi.ShellAPI, Vcl.Menus;

const
  WM_TRAYMSG = WM_USER + 101;                   //自定义托盘消息

const
  NIF_INFO = $00000010;          //气泡显示标志
  NIIF_NONE = $00000000;          //无图标
  NIIF_INFO = $00000001;          //信息图标
  NIIF_WARNING = $00000002;          //警告图标
  NIIF_ERROR = $00000003;          //错误图标
  NIIF_USER = $00000004;          //XP使用hIcon图标

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
  TKillGreyForm = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    show: TMenuItem;
    N1: TMenuItem;
    Button2: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure showClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMTrayMsg(var Msg: TMessage); message WM_TRAYMSG;    //声明托盘消息
    procedure WMSysCommand(var Msg: TMessage); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  KillGreyForm: TKillGreyForm;
  LgNotifyIcon: TNotifyIconDataEx;                    //定义托盘图标结构体
  gbsw: Boolean;

implementation

{$R *.dfm}

function EnumChildWndProc(AhWnd: LongInt; AlParam: lParam): boolean; stdcall;
var
  WndClassName: array[0..254] of Char;
  WndCaption: array[0..254] of Char;
  cRect: TRect;
begin

  GetClassName(AhWnd, WndClassName, 254); //获取类名
  GetWindowText(AhWnd, WndCaption, 254); //获取控件caption
  GetWindowRect(AhWnd, cRect); //获取控件的Rect

//  if (string(wndCaption) = '查找') then
//    SearchButtonHandle := AhWnd;
//
//  if (string(wndClassName) = 'Edit') then
//    SearchEditHandle := AhWnd;
//
//  if (string(wndClassName) = 'DSUI:SearchResultsView') then
//    ResultHandle := AhWnd;

  EnableWindow(AhWnd, True);

  result := true;
end;

procedure TKillGreyForm.Button1Click(Sender: TObject);
begin
  if gbsw then
  begin
    gbsw := False;
    Button1.Caption := '激活';
    timer1.Enabled := False;
  end
  else
  begin
    gbsw := True;
    Button1.Caption := '停止';
    timer1.Enabled := True;
  end;
end;

procedure TKillGreyForm.Button2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, 'http://crazymelon.faisco.cn/', nil, nil, SW_SHOWNORMAL);
end;

procedure TKillGreyForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 // Self.Visible := False;
  Hide;
  Action := caNone;
end;

procedure TKillGreyForm.FormCreate(Sender: TObject);
begin
  Self.Position := poOwnerFormCenter;
  FormStyle := fsStayOnTop;
  Edit1.Clear;
  Edit2.Clear;

  Timer1.Enabled := False;

  gbsw := False;

  with LgNotifyIcon do
  begin
    cbSize := SizeOf(TNotifyIconDataEx);
    Wnd := Self.Handle;
    uID := 1;
    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP + NIF_INFO;   //图标、消息、提示信息
    uCallbackMessage := WM_TRAYMSG;
    hIcon := Application.Icon.Handle;
    szTip := '灰键克星';
//    szInfo := 'hint';
//    szInfoTitle := '提示信息！';
    dwInfoFlags := NIIF_USER;
  end;
  Shell_NotifyIcon(NIM_ADD, @LgNotifyIcon);

end;

procedure TKillGreyForm.FormDestroy(Sender: TObject);
begin
  shell_notifyicona(NIM_DELETE, @LgNotifyIcon);
end;

procedure TKillGreyForm.FormShow(Sender: TObject);
var
  Style: Integer;
begin
  Style := GetWindowLong(Handle, GWL_EXSTYLE);
  SetWindowLong(Handle, GWL_EXSTYLE, Style and (not WS_EX_APPWINDOW));
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TKillGreyForm.N1Click(Sender: TObject);
begin
  shell_notifyicona(NIM_DELETE, @LgNotifyIcon);
  Application.Terminate;
end;

procedure TKillGreyForm.showClick(Sender: TObject);
begin
  SetForegroundWindow(Self.Handle);
  WindowState := TWindowState(tag);
  Visible := True;
end;

procedure TKillGreyForm.Timer1Timer(Sender: TObject);
var
  pt: TPoint;
  hhh: THandle;
  WndClassName: array[0..254] of Char;
  id: Integer;
begin
  GetCursorPos(pt);

  hhh := WindowFromPoint(pt);
  GetWindowText(hhh, WndClassName, 254);

  if hhh <> 0 then
  begin
    EnumChildWindows(hhh, @EnumChildWndProc, 0); //遍历登录窗体里面的子控件 获取其句柄

  end;

//  if temp <> 0then
//    handle := temp;


  Edit1.Text := WndClassName;
  Edit2.text := Integer(hhh).ToString;

end;

{-------------------------------------------------------------------------------
 Description: 自定义的托盘消息
-------------------------------------------------------------------------------}

procedure TKillGreyForm.WMTrayMsg(var Msg: TMessage);
var
  p: TPoint;
begin
  case Msg.LParam of
    WM_LBUTTONDOWN:
      begin
        SetForegroundWindow(Self.Handle);
//         ShowWindow(Self.Handle, SW_SHOW);
        WindowState := TWindowState(tag);
        Visible := True;   //显示窗体
      end;
    WM_RBUTTONDOWN:
      begin
        SetForegroundWindow(Self.Handle);   //把窗口提前
        GetCursorPos(p);
        PopupMenu1.Popup(p.X, p.Y);
      end;
  end;
end;
{-------------------------------------------------------------------------------
 Description: 截获窗体最小化消息，最小化到托盘
-------------------------------------------------------------------------------}

procedure TKillGreyForm.WMSysCommand(var Msg: TMessage);
begin
  if Msg.WParam = SC_ICON then
  begin
//    Self.Visible := False ;
//    Application.Minimize;
 //   ShowWindow(Application.Handle,SW_HIDE);
    Self.Close;
  end
  else if Msg.WParam = SC_CLOSE then

//    case Application.MessageBox('是否退出程序？', '提示', MB_YESNO + MB_ICONQUESTION +
//      MB_DEFBUTTON2) of
//      IDYES:
//        begin
//          Application.Terminate;
//          Shell_NotifyIcon(NIM_DELETE, @LgNotifyIcon);
//        end;
//      IDNO:
//        begin
//          Close;
//        end;
//    end
  begin
    Application.Terminate;
    Shell_NotifyIcon(NIM_DELETE, @LgNotifyIcon);
  end

  else
    inherited;
 //   DefWindowProc(Self.Handle, Msg.Msg, Msg.WParam, Msg.LParam);


end;

end.

