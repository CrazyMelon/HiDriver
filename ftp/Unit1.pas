unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, ExtCtrls,Jpeg, IdGlobal, IdExplicitTLSClientServerBase;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Button2: TButton;
    ftp: TIdFTP;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  RootDIR, RltDIR, File_Name: string;
  I: Integer;
  List: TStringList;
  Stream: TStream;
  JPG: TJPEGImage;

begin
  Stream:= TMemoryStream.Create;
  JPG := TJPEGImage.Create;
  //  RootDIR, RltDIR, File_Name: string;
  try
    FTP.Host:= '192.168.7.100';  // FTP地址
    FTP.Username:= 'sxw1013';
    FTP.Password:= '611714';
   if not  Ftp.Connected then
    FTP.Connect;//(True, 5000);  // 连接
    if FTP.Connected then begin
      RootDIR:= Utf8ToAnsi( FTP.RetrieveCurrentDir );  // 获取根路径
      RltDIR:= '/picture';  // 设置相对路径
      FTP.Get(AnsiToUtf8(RootDIR+RltDIR+'/'+'123.jpg'), Stream,true); // 获取文件
      Stream.Position := 0;
      JPG.LoadFromStream(Stream);
      Image1.Picture.Assign(JPG);
    end;
  finally
    JPG.free    ;
    Stream.Free ;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
VAR
     Stream: TStream;
    RootDIR, RltDIR, File_Name: string;
begin
   try
     Stream:= TMemoryStream.Create;
     Stream.Position := 0;
     if  Ftp.Connected then
     begin
       if image1.Picture<>nil then
       begin
         RootDIR:= Utf8ToAnsi( FTP.RetrieveCurrentDir );  // 获取根路径
          RltDIR:= '/123';  // 设置相对路径
         image1.Picture.Graphic.SaveToStream(Stream);
         Ftp.Put(Stream ,RootDIR+RltDIR+'/'+'33333.jpg',true);
      end;
    end;
  finally
    stream.Free ;
  end;
end;

end.
