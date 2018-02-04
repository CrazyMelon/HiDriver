unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, AppEvnts, StdCtrls, Menus, Vcl.ExtCtrls;

const
  WM_NID = WM_User + 1000; //����һ������

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

    { Private declarations } // ������������

    procedure SysCommand(var SysMsg: TMessage); message WM_SYSCOMMAND;
    procedure WMNID(var msg: TMessage); message WM_NID;
  public
  end;

var
  Form1: TForm1;
  NotifyIcon, NotifyIcon1, NotifyIcon2: TNotifyIconDataEx; // ȫ�ֱ���
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

  GetCursorPos(mousepos); //��ȡ���λ��

  case msg.LParam of

    WM_LBUTTONUP: // ����������������

      begin

        Form1.Visible := not Form1.Visible; // ��ʾ���������

        SetWindowPos(Application.Handle, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW); // ����������ʾ����

      end;

    WM_RBUTTONUP:

      PopupMenu1.Popup(mousepos.X, mousepos.Y); // �����˵�

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

  trayhint := '�˺�"' + '"��½�ɹ���';

  traymessage := 'HiTools' + #13#10 + '�˺ţ�';

  with NotifyIcon do
  begin
    cbSize := SizeOf(TNotifyIconDataEx);
    Wnd := Self.Handle;
    uID := 1;
    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP + NIF_INFO;   //ͼ�ꡢ��Ϣ����ʾ��Ϣ
    uCallbackMessage := WM_NID;
    hIcon := Application.Icon.Handle;
    szTip := '';
    CopyMemory(@szTip[0], PChar(traymessage), ByteLength(traymessage));
 //   szTip := 'HiTools';

    szInfo := '';
    CopyMemory(@szInfo[0], PChar(trayhint), ByteLength(trayhint));
//    szInfo :=  trayhint;
    szInfoTitle := '��ʾ��Ϣ��';
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

  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon1); // ɾ������ͼ��

end;

procedure TForm1.SysCommand(var SysMsg: TMessage);
begin

  case SysMsg.WParam of

    SC_MINIMIZE: // ����С��ʱ

      begin

        SetWindowPos(Application.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_HIDEWINDOW);

        Hide; // �����������س���

        Shell_NotifyIcon(NIM_MODIFY, @NotifyIcon); // ����������ʾͼ��

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
  Shell_NotifyIcon(NIM_MODIFY, @NotifyIcon1); // ����������ʾͼ��

end;

{������������Ϊ�����Ҽ��˵�����������ӹ���}

procedure TForm1.N1Click(Sender: TObject);
begin

  ShowMessage('Delphi����С����');

end;

procedure TForm1.N2Click(Sender: TObject);
begin

  Form1.Visible := true; // ��ʾ����

  SetWindowPos(Application.Handle, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW);

  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon); // ɾ������ͼ��

end;

procedure TForm1.N3Click(Sender: TObject);
begin

  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon);

  Application.Terminate;

end;

end.

