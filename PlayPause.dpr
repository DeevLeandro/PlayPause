program PlayPause;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  FrmPrincial in 'FrmPrincial.pas' {FrmPrincial1},
  MusicPlayer.Android in 'MusicPlayer.Android.pas',
  MusicPlayer.iOS in 'MusicPlayer.iOS.pas',
  MusicPlayer in 'MusicPlayer.pas',
  MusicPlayer.Utils in 'MusicPlayer.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincial1, FrmPrincial1);
  Application.Run;
end.
