unit NewHiScore;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TNewHiScoreForm = class(TForm)
    InfoText: TLabel;
    EditInitials: TEdit;
    SaveHiScoreButton: TButton;
    Conn: TFDConnection;
    procedure SaveHiScoreButtonClick(Sender: TObject);
  private
    _position: Integer;
    _numMoves: Integer;
  public
    constructor Create(owner: TComponent; position: Integer; num_moves: Integer); reintroduce;
  end;

var
  NewHiScoreForm: TNewHiScoreForm;
  EditInitials: TEdit;

implementation

{$R *.dfm}

constructor TNewHiScoreForm.Create(owner: TComponent; position: Integer; num_moves: Integer);
begin
  inherited Create(owner);
  _position := position;
  _numMoves := num_moves;
  InfoText.Caption :=
    Format(
      'You score is good enough to put you in the hi score list at postion %d.' +
      sLineBreak + 'Please enter your initials below.',
      [position]
    );
end;

procedure TNewHiScoreForm.SaveHiScoreButtonClick(Sender: TObject);
var
  query: TFDQuery;
begin
  Conn.Open();

  query := TFDQuery.Create(nil);
  query.Connection := Conn;
  query.SQL.Text := 'SELECT initials, num_moves FROM hiscores ORDER BY num_moves ASC, initials ASC LIMIT 10;';
  query.OpenOrExecute;
  // If the hiscore list is "full", we need to remove the last entry
  if query.RecordCount = 10 then
    begin
      query.Last();
      query.Delete();
    end;
  // Add the new hiscore
  query.AppendRecord([EditInitials.Text, _numMoves]);

  query.Free();

  Conn.Close();

  Screen.ActiveForm.Close();
end;

end.
