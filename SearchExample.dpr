program SearchExample;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  UMain in 'UMain.pas' {MainForm};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
