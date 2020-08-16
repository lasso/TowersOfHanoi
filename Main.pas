unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ToHClasses, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.StdCtrls, Vcl.ExtCtrls, pngimage, HiScore,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.UITypes, FireDAC.Stan.Param, NewHiscore;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    InfoBox: TMemo;
    HiScoreButton: TButton;
    Conn: TFDConnection;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure HiScoreButtonClick(Sender: TObject);

  private
    _game: TTohGame;
    procedure AddNewHiscore(position: Integer);
    procedure AskForNewGame();
    procedure CheckForHiScore();
    function GetImageName(tower: TTower): String;
    procedure LoadImage(owner: TImage; resourceName: String);
    procedure UpdateControls;
    procedure UpdateImages;
    procedure UpdateStatus;
  public
    constructor Create(owner: TComponent); override;
    procedure UpdateAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.AddNewHiscore(position: Integer);
var
  newHiscoreForm: TNewHiscoreForm;
begin
   newHiscoreForm := TNewHiscoreForm.Create(Screen.ActiveForm, position, _game.NumMoves);
   newHiscoreForm.ShowModal();
end;

procedure TMainForm.AskForNewGame();
var
  buttonSelected: Integer;
begin
  buttonSelected := MessageDlg(
    'Congratulations!' + sLineBreak +
    'You completed the game.' + sLineBreak +
    'Try again?',
    mtConfirmation,
    [mbYes, mbNo],
    0
  );

  if buttonSelected = mrYes then
    begin
      _game.Free();
      InfoBox.Lines.Clear(); // Clear the infobox
      _game := TTohGame.Create();
      UpdateAll();
    end
  else
    begin
      ShowMessage('Thanks and goodbye!');
      Application.MainForm.Close();
    end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  _game.MoveBlock(1, 2);
  UpdateAll();
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  _game.MoveBlock(1, 3);
  UpdateAll();
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  _game.MoveBlock(2, 1);
  UpdateAll();
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  _game.MoveBlock(2, 3);
  UpdateAll();
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  _game.MoveBlock(3, 2);
  UpdateAll();
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  _game.MoveBlock(3, 1);
  UpdateAll();
end;

procedure TMainForm.CheckForHiScore();
var
  query: TFDQuery;
  beatenBy: Integer;
begin
   Conn.Open();

   // To qualify for the hiscore list, the game needs to be in the top ten.
   query := TFDQuery.Create(nil);
   query.Connection := Conn;
   query.SQL.Text :=
     'SELECT COUNT(initials) AS beatenBy FROM hiscores WHERE num_moves <= :numMoves';
   query.ParamByName('numMoves').AsInteger := _game.NumMoves;
   query.OpenOrExecute();
   query.First();
   beatenBy := query.FieldByName('beatenBy').Value;
   query.Free();
   Conn.Close();

   if beatenBy < 10 then AddNewHiscore(beatenBy + 1);
   AskForNewGame();
end;

constructor TMainForm.Create(owner: TComponent);
begin
  inherited Create(owner);
  _game := TTohGame.Create();
  UpdateAll();
end;

function TMainForm.GetImageName(tower: TTower): String;
var
  b: TBlock;
  i: Integer;
  r: String;
begin
  for i := Low(tower.Blocks) to tower.Height do
    begin
      b := tower.Blocks[i];
      if b = Red then r := Format('%sR', [r])
      else if b = Green then r := Format('%sG', [r])
      else if b = Blue then r := Format('%sB', [r])
      else raise Exception.Create('Invalid block');
    end;
  if r = '' then Result := 'Tower_E'
  else Result := Format('Tower_%s', [r]);
end;

procedure TMainForm.HiScoreButtonClick(Sender: TObject);
var
  hiscoreForm: THiScoreForm;
begin
  hiScoreForm := THiScoreForm.Create(Screen.ActiveForm);
  hiScoreForm.ShowModal();
end;

procedure TMainForm.LoadImage(owner: TImage; resourceName: String);
var
  image: TPngImage;
  stream: TResourceStream;
begin
  image := TPngImage.Create;
  try
    stream := TResourceStream.Create(hInstance, resourceName, RT_RCDATA);
    try
      image.LoadFromStream(stream);
      owner.Picture.Graphic := image;
    finally
      stream.Free;
    end;
  finally
    image.Free;
  end;
end;

procedure TMainForm.UpdateAll();
begin
  UpdateControls();
  UpdateImages();
  UpdateStatus();
end;

procedure TMainForm.UpdateControls;
begin
  // Controls for first tower
  Button1.Enabled := _game.CanMoveBlock(1, 2);
  Button2.Enabled := _game.CanMoveBlock(1, 3);

  // Controls for second tower
  Button3.Enabled := _game.CanMoveBlock(2, 1);
  Button4.Enabled := _game.CanMoveBlock(2, 3);

  // Controls for third tower
  Button5.Enabled := _game.CanMoveBlock(3, 2);
  Button6.Enabled := _game.CanMoveBlock(3, 1);
end;

procedure TMainForm.UpdateImages();
begin
  LoadImage(Image1, GetImageName(_game.Towers[1]));
  LoadImage(Image2, GetImageName(_game.Towers[2]));
  LoadImage(Image3, GetImageName(_game.Towers[3]));
end;

procedure TMainForm.UpdateStatus();
var
  i: Integer;
  msg: String;
  t: TTower;
begin
  InfoBox.Lines.Add(Format('Moves performed: %d', [_game.NumMoves]));
  for i := Low(_game.Towers) to High(_game.Towers) do
    begin
      t := _game.Towers[i];
      msg := Format('Tower %d is %s', [i, t.ToString()]);
      InfoBox.Lines.Add(msg)
    end;
  if _game.IsComplete() then
    InfoBox.Lines.Add('You beat the game!')
  else
    InfoBox.Lines.Add('There is still some work to do...');

  InfoBox.Lines.Add('----------------------------------------');

  // If the game is complete, check if the user belongs to the hiscore list
  if _game.IsComplete() then CheckForHiScore();
end;

end.
