unit HIScore;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDac.Dapt, Vcl.Grids;

type
  THiscore = Record
    initials: String[3];
    num_moves: Integer;
  end;
  THiscoreList = array of THiScore;
  THiScoreForm = class(TForm)
    Conn: TFDConnection;
    HiScoreGrid: TStringGrid;
  private
    procedure CheckTableExist();
    function LoadHiScores(): THiscoreList;
    procedure UpdateGrid(scores: THiscoreList);
  public
    constructor Create(owner: TComponent); override;
  end;

var
  HiScoreForm: THiScoreForm;

implementation

{$R *.dfm}

constructor THiScoreForm.Create(owner: TComponent);
begin
  inherited Create(owner);

  // Open connection
  Conn.Open();

  // Ensure that the hiscores table exist.
  CheckTableExist();

  // Load hiscores and update the grid
  UpdateGrid(LoadHiscores());

  // Close connection
  Conn.Close();
end;

procedure THiScoreForm.CheckTableExist();
var
  query: TFDQuery;
begin
  // Check if hi score table exists
  query := TFDQuery.Create(nil);
  query.Connection := Conn;
  query.SQL.Text := 'SELECT 1 FROM sqlite_master WHERE type=''table'' AND name=''hiscores'';';
  query.OpenOrExecute();
  if query.IsEmpty then
    // Hi score table does not exist yet.
    begin
      query.Free();
      query := TFDQuery.Create(nil);
      query.Connection := Conn;
      query.SQL.Text := 'CREATE TABLE hiscores (initials CHAR(3), num_moves INT);';
      query.ExecSQL();
      query.Free();
    end
  else query.Free();
end;

function THiscoreForm.LoadHiScores(): THiscoreList;
var
  query: TFDQuery;
  idx: Integer;
  allScores: THiscoreList;
  score: ^THiscore;
begin
  query := TFDQuery.Create(nil);
  query.Connection := Conn;
  query.SQL.Text := 'SELECT initials, num_moves FROM hiscores ORDER BY num_moves ASC, initials ASC LIMIT 10;';
  query.OpenOrExecute();
  if not query.IsEmpty then
    begin
      // Resize the array to the number of db rows (max 10)
      SetLength(allScores, query.RecordCount);
      idx := 0;
      // Move to db row
      query.First();
      while not query.Eof do
        begin
          // For each db row, set the pointer to a specific record in the
          // array and write the fields.
          score := @allScores[idx];
          score.initials := query.FieldByName('initials').Value;
          score.num_moves := query.FieldByName('num_moves').Value;
          idx := idx + 1;
          query.Next();
        end;
    end;
  query.Free();
  Result := allScores;
end;

procedure THiscoreForm.UpdateGrid(scores: THiscoreList);
var
 i: Integer;
begin
  for i := Low(scores) to High(scores) do
    begin
      HiscoreGrid.Cells[0, i] := scores[i].initials;
      HiScoreGrid.Cells[1, i] := IntToStr(scores[i].num_moves);
    end;
end;

end.
