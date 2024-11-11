unit FrmPrincial;

interface

uses
  MusicPlayer.Utils,
{$IFDEF IOS}
  MusicPlayer.iOS,
{$ENDIF}
{$IFDEF ANDROID}
  MusicPlayer.Android,
{$ENDIF}
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.StdCtrls,
  System.SysUtils,
  System.UITypes,
  FMX.ListBox,
  System.Classes,
  FMX.Layouts,
  FMX.TabControl,
  System.Actions,
  FMX.ActnList,
  FMX.ListView.Types,
  FMX.ListView,
  FMX.Objects,
  Data.Bind.GenData,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  FMX.Edit,
  FMX.Dialogs,
  FMX.MobilePreview,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation,
  FMX.Media,
  FMX.Ani,
  MusicPlayer,
  FMX.MultiResBitmap,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  System.JSON,
  JSON.BSON,
  JSON.Types,
  JSON.Utils,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,
  IdHTTP,
  FMX.Helpers.Android,
  Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText;

type
  TFrmPrincial1 = class(TForm)
    Layout1: TLayout;
    tcUITabs: TTabControl;
    tiAlbums: TTabItem;
    lvAlbums: TListView;
    tiSongs: TTabItem;
    lvSongs: TListView;
    tiNowPlaying: TTabItem;
    tbNowPlaying: TToolBar;
    btnPrev: TButton;
    btnNext: TButton;
    lyState: TLayout;
    btnPlay: TButton;
    btnPause: TButton;
    btnStop: TButton;
    lblArtist: TLabel;
    lblTitle: TLabel;
    lblAlbum: TLabel;
    lblDuration: TLabel;
    lblArtistVal: TLabel;
    lblTitleVal: TLabel;
    lblAlbumVal: TLabel;
    lblDurationVal: TLabel;
    tbProgress: TTrackBar;
    tiSettings: TTabItem;
    SettingsList: TListBox;
    RepeatModes: TListBoxGroupHeader;
    All: TListBoxItem;
    One: TListBoxItem;
    None: TListBoxItem;
    Default: TListBoxItem;
    ShuffleMusic: TListBoxGroupHeader;
    ShufffleMode: TListBoxItem;
    swShuffleMode: TSwitch;
    VolumeHeader: TListBoxGroupHeader;
    VolumeListItem: TListBoxItem;
    VolumeTrackBar: TTrackBar;
    Rectangle2: TRectangle;
    FloatAnimation1: TFloatAnimation;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    btnMusica: TRectangle;
    btnconfig: TRectangle;
    btnPla: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Rectangle3: TRectangle;
    Label4: TLabel;
    Rectangle4: TRectangle;
    Label5: TLabel;
    Rectangle5: TRectangle;
    Label6: TLabel;
    Layout3: TLayout;
    Rectangle6: TRectangle;
    Label7: TLabel;
    Timer1: TTimer;
    TiYoutube: TTabItem;
    Layout4: TLayout;
    Layout5: TLayout;
    Rectangle7: TRectangle;
    Label8: TLabel;
    Layout7: TLayout;
    BntBaixar: TRectangle;
    Label10: TLabel;
    Rectangle9: TRectangle;
    btnDownload: TRectangle;
    Label9: TLabel;
    btnYoutube: TRectangle;
    Label11: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure lvSongsChange(Sender: TObject);
    procedure lvAlbumsChange(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure AllClick(Sender: TObject);
    procedure swShuffleModeSwitch(Sender: TObject);
    procedure VolumeTrackBarChange(Sender: TObject);
    procedure tbProgressChange(Sender: TObject);
    procedure btnMusicaClick(Sender: TObject);
    procedure btnPlaClick(Sender: TObject);
    procedure btnconfigClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BntBaixarClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnYoutubeClick(Sender: TObject);
  private
    procedure UpdateSongs;
    procedure StateChanged(state: TMPPlaybackState);
    procedure UpdateNowPlaying(newIndex: Integer);
    procedure SongChanged(newIndex: Integer);
    procedure DoUpdateUI(newPos: Single);
    procedure AbrirLinkNoGoogle(const URL: string);
      { Private declarations }
  public
      { Public declarations }
  end;

var
  FrmPrincial1: TFrmPrincial1;

implementation

{$R *.fmx}

procedure TFrmPrincial1.StateChanged(state: TMPPlaybackState);
begin
    // Atualiza a interface de acordo com o estado do player (Play, Pause, Stop)
  btnPlay.Enabled    := not (state in [ TMPPlaybackState.Playing ]);
  btnPause.Enabled   := not (state in [ TMPPlaybackState.Paused, TMPPlaybackState.Stopped ]);
  btnStop.Enabled    := not (state in [ TMPPlaybackState.Stopped ]);
  tbProgress.Enabled := not (state in [ TMPPlaybackState.Stopped, TMPPlaybackState.Paused ]);
  btnNext.Enabled    := not (state in [ TMPPlaybackState.Stopped ]);
  btnPrev.Enabled    := not (state in [ TMPPlaybackState.Stopped ]);
end;

procedure TFrmPrincial1.swShuffleModeSwitch(Sender: TObject);
begin
    // Atualiza o modo shuffle do player
  TMusicPlayer.DefaultPlayer.ShuffleMode := swShuffleMode.IsChecked;
end;

procedure TFrmPrincial1.tbProgressChange(Sender: TObject);
begin

    // Atualizar a posição da música
  TMusicPlayer.DefaultPlayer.Time := (tbProgress.Value * TMusicPlayer.DefaultPlayer.Duration) / 100;
end;

procedure TFrmPrincial1.Timer1Timer(Sender: TObject);
var
  CurMin, CurSec, TotalMin, TotalSec: Integer;
  CurrentTime, TotalTime            : Single;
begin
    // Verifique se o player está tocando
  if TMusicPlayer.DefaultPlayer.IsPlaying then
  begin
    CurrentTime := TMusicPlayer.DefaultPlayer.Time;
    TotalTime   := TMusicPlayer.DefaultPlayer.Duration;

    CurMin := Trunc(CurrentTime / 60000); // Converte milissegundos para minutos
    CurSec := Trunc((Trunc(CurrentTime) mod 60000) / 1000); // Converte o restante para segundos

    TotalMin := Trunc(TotalTime / 60000);
    TotalSec := Trunc((Trunc(TotalTime) mod 60000) / 1000);

    lblDurationVal.Text := Format('%.2d:%.2d', [ CurMin, CurSec, TotalMin, TotalSec ]);
  end
  else
  begin
    lblDurationVal.Text := '00:00';
  end;
end;

procedure TFrmPrincial1.UpdateNowPlaying(newIndex: Integer);
begin

    // Atualiza as informações da música atual na interface
  lblArtistVal.Text   := TMusicPlayer.DefaultPlayer.Playlist[ newIndex ].Artist;
  lblTitleVal.Text    := TMusicPlayer.DefaultPlayer.Playlist[ newIndex ].Title;
  lblAlbumVal.Text    := TMusicPlayer.DefaultPlayer.Playlist[ newIndex ].Album;
  lblDurationVal.Text := TMusicPlayer.DefaultPlayer.Playlist[ newIndex ].Duration;
end;

procedure TFrmPrincial1.AllClick(Sender: TObject);
var
  Item: TListBoxItem;
  I   : Integer;
begin
    // Atualiza o modo de repetição baseado na seleção do usuário
  if Sender is TListBoxItem then
  begin
    for I                                            := 0 to SettingsList.Items.Count - 1 do
      SettingsList.ItemByIndex(I).ItemData.Accessory := TListBoxItemData.TAccessory.aNone;

    Item := Sender as TListBoxItem;
    if Item.Text = 'Tudo' then
      TMusicPlayer.DefaultPlayer.RepeatMode := TMPRepeatMode.All;
    if Item.Text = 'Um' then
      TMusicPlayer.DefaultPlayer.RepeatMode := TMPRepeatMode.One;
    if Item.Text = 'Nenhum' then
      TMusicPlayer.DefaultPlayer.RepeatMode := TMPRepeatMode.None;
    if Item.Text = 'Padrão' then
      TMusicPlayer.DefaultPlayer.RepeatMode := TMPRepeatMode.Default;

    Item.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark;
  end;
end;

procedure TFrmPrincial1.btnNextClick(Sender: TObject);
begin
    // Avança para a próxima música
  TMusicPlayer.DefaultPlayer.Next;
  StateChanged(TMusicPlayer.DefaultPlayer.PlaybackState);
  FloatAnimation1.Start;
end;

procedure TFrmPrincial1.btnPauseClick(Sender: TObject);
begin
    // Pausa a reprodução
  TMusicPlayer.DefaultPlayer.Pause;
  StateChanged(TMPPlaybackState.Paused);
  FloatAnimation1.Stop;
end;

procedure TFrmPrincial1.btnPlaClick(Sender: TObject);
begin
    // Mostra a aba de reprodução
  tcUITabs.ActiveTab := tiNowPlaying;
end;

procedure TFrmPrincial1.btnPlayClick(Sender: TObject);
begin
    // Inicia a reprodução
  TMusicPlayer.DefaultPlayer.Play;
  StateChanged(TMPPlaybackState.Playing);
  FloatAnimation1.Start;
end;

procedure TFrmPrincial1.btnPrevClick(Sender: TObject);
begin
    // Volta para a música anterior
  TMusicPlayer.DefaultPlayer.Previous;
  StateChanged(TMusicPlayer.DefaultPlayer.PlaybackState);
  FloatAnimation1.Start;
end;

procedure TFrmPrincial1.btnStopClick(Sender: TObject);
begin
    // Para a reprodução
  TMusicPlayer.DefaultPlayer.Stop;
  StateChanged(TMPPlaybackState.Stopped);
  FloatAnimation1.Stop;
  Timer1Timer(Sender);

end;

procedure TFrmPrincial1.btnYoutubeClick(Sender: TObject);
begin
AbrirLinkNoGoogle('https://www.youtube.com/');
end;

procedure TFrmPrincial1.SongChanged(newIndex: Integer);
var
  handler: TNotifyEvent;
begin
  handler           := lvSongs.OnChange;
  lvSongs.OnChange  := nil;
  lvSongs.ItemIndex := newIndex;
  UpdateNowPlaying(newIndex);
  lvSongs.OnChange := handler;
  StateChanged(TMPPlaybackState.Playing);
end;

procedure TFrmPrincial1.DoUpdateUI(newPos: Single);
var
  handler: TNotifyEvent;
begin
  handler             := tbProgress.OnChange;
  tbProgress.OnChange := nil;
  tbProgress.Value    := newPos;
  tbProgress.OnChange := handler;
end;

procedure TFrmPrincial1.FormCreate(Sender: TObject);
var
  Item : TListViewItem;
  Album: TMPAlbum;
begin
    // Inicializa o player e configura os eventos
{$IFDEF ANDROID}
    //  tcUITabs.TabPosition := TTabPosition.Top;
{$ENDIF}
  TMusicPlayer.DefaultPlayer.OnSongChange  := SongChanged;
  TMusicPlayer.DefaultPlayer.OnProcessPlay := DoUpdateUI;
  TMusicPlayer.DefaultPlayer.GetAlbums;
  TMusicPlayer.DefaultPlayer.GetSongs;
  lvAlbums.BeginUpdate;
  for Album in TMusicPlayer.DefaultPlayer.Albums do
  begin
    Item        := lvAlbums.Items.Add;
    Item.Text   := Album.Name;
    Item.Detail := Album.Artist;
    Item.Bitmap := Album.Artwork
  end;
  lvAlbums.EndUpdate;
  UpdateSongs;
  FloatAnimation1.Stop;
  tcUITabs.ActiveTab := tiSongs;
  Memo1.ReadOnly := True;
end;

procedure TFrmPrincial1.lvAlbumsChange(Sender: TObject);
begin
    // Atualiza a lista de músicas ao mudar a seleção de álbuns
  TMusicPlayer.DefaultPlayer.GetSongsInAlbum(TMusicPlayer.DefaultPlayer.Albums[ lvAlbums.ItemIndex ].Name);
  UpdateSongs;
  tcUITabs.SetActiveTabWithTransition(tiSongs, TTabTransition.Slide);
end;

procedure TFrmPrincial1.lvSongsChange(Sender: TObject);
begin
    // Atualiza a interface ao mudar a seleção de músicas
  TMusicPlayer.DefaultPlayer.PlayByIndex(lvSongs.ItemIndex);
  UpdateNowPlaying(lvSongs.ItemIndex);
  tcUITabs.SetActiveTabWithTransition(tiNowPlaying, TTabTransition.Slide);
  StateChanged(TMPPlaybackState.Playing);
  FloatAnimation1.Start;
end;

procedure TFrmPrincial1.BntBaixarClick(Sender: TObject);
begin
  tcUITabs.ActiveTab := TiYoutube;
end;

procedure TFrmPrincial1.btnconfigClick(Sender: TObject);
begin
    // Mostra a aba de configurações
  tcUITabs.ActiveTab := tiSettings;
end;

procedure TFrmPrincial1.btnDownloadClick(Sender: TObject);
begin
AbrirLinkNoGoogle('https://y2meta.is/pt/youtube-to-mp3/');
end;

procedure TFrmPrincial1.btnMusicaClick(Sender: TObject);
begin
    // Mostra a aba de músicas
  tcUITabs.ActiveTab := tiSongs;
end;

procedure TFrmPrincial1.UpdateSongs;
var
  song: TMPSong;
  Item: TListViewItem;
begin
    // Atualiza a lista de músicas na interface
  lvSongs.BeginUpdate;
  lvSongs.Items.Clear;
{$IFDEF ANDROID}
  if Length(TMusicPlayer.DefaultPlayer.Playlist) = 0 then
  begin
    ShowMessage('Não encontramos nenhuma música, saindo.');
    Halt;
  end;
{$ENDIF}
  for song in TMusicPlayer.DefaultPlayer.Playlist do
  begin
    Item := lvSongs.Items.Add;
    if (song.Artist <> 'Desconhecido') then
      Item.Text := Format('%s - %s', [ song.Artist, song.Title ])
    else
      Item.Text := song.Title;
  end;
  lvSongs.EndUpdate;
end;

procedure TFrmPrincial1.VolumeTrackBarChange(Sender: TObject);
begin
    //Ajusta volume
  TMusicPlayer.DefaultPlayer.Volume := VolumeTrackBar.Value;
end;

procedure TFrmPrincial1.AbrirLinkNoGoogle(const URL: string);
var
  Intent: JIntent;
begin
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI(URL));
  TAndroidHelper.Context.startActivity(Intent);
end;

end.
