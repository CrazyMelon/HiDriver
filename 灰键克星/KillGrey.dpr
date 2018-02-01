program KillGrey;

uses
  Vcl.Forms,windows,
  Unit1 in 'Unit1.pas' {KillGreyForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;

  Application.CreateForm(TKillGreyForm, KillGreyForm);
  Application.Run;
end.
