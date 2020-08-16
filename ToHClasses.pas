unit ToHClasses;

interface

uses SysUtils, typinfo;

type
  TBlock = (Unset,Red,Green,Blue);
  TBlockArray = array[1..3] of TBlock;
  TTower = class
    private
      _blocks: TBlockArray;
      function GetBlocks(): TBlockArray;
      function GetHeight(): Integer;
      function BlockAsString(value: TBlock): String;
    public
      constructor Create();
      property Blocks: TBlockArray read GetBlocks;
      function CanPush(block: TBlock): Boolean;
      function CanPop(): Boolean;
      property Height: Integer read GetHeight;
      function Peek(): TBlock;
      procedure Push(block: TBlock);
      function Pop(): TBlock;
      function ToString(): String; override;
  end;
  TTowerArray = array[1..3] of TTower;
  TToHGame = class
    private
      _numMoves: Integer;
      _towers: TTowerArray;
      function GetNumMoves(): Integer;
      function GetTowers(): TTowerArray;
    public
      function CanMoveBlock(source: Integer; destination: Integer): Boolean;
      constructor Create();
      function IsComplete(): Boolean;
      procedure MoveBlock(source: Integer; destination: Integer);
      property NumMoves: Integer read GetNumMoves;
      property Towers: TTowerArray read GetTowers;
  end;

implementation

constructor TTower.Create();
var
  i: Integer;
begin
  for i := Low(_blocks) to High(_blocks) do
    _blocks[i] := Unset
end;

function TTower.GetBlocks(): TBlockArray;
begin
  Result := _blocks;
end;

function TTower.GetHeight(): Integer;
var
  i: Integer;
begin
  for i := Low(_blocks) to High(_blocks) do
    if _blocks[i] = Unset then break;
  Result := i - 1;
end;

function TTower.CanPush(block: TBlock): Boolean;
var
  b: TBlock;
begin
  b := Peek();
  if b = Unset then Result := true // Any block can be moved to an empty position
  else if b = Red then Result := block = Green
  else if b = Green then Result := block = Blue
  else Result := false; // No block can be moved to a full tower
end;

function TTower.CanPop(): Boolean;
begin
  Result := Height > 0;
end;

function TTower.Peek(): TBlock;
begin
  if Height > 0 then
    Result := _blocks[Height]
  else
    Result := Unset;
end;

procedure TTower.Push(block: TBlock);
begin
  _blocks[Height + 1] := block;
end;

function TTower.Pop(): TBlock;
begin
  Result := _blocks[Height];
  _blocks[Height] := Unset;
end;

function TTower.ToString(): String;
var
  i: Integer;
  r: String;
begin
  if Height = 0 then
    Result := 'Empty'
  else
    begin
      r := BlockAsString(_blocks[Low(_blocks)]);
      for i := Low(_blocks) + 1 to Height do
        r := Format('%s, %s', [r, BlockAsString(_blocks[i])]);
      Result := r;
    end;
end;

function TTower.BlockAsString(value: TBlock): String;
begin
    Result := GetEnumName(typeInfo(TBlock), Ord(value));
end;

function TTohGame.CanMoveBlock(source: Integer; destination: Integer): Boolean;
var
  s: TTower;
  d: TTower;
begin
  s := _towers[source];
  d := _towers[destination];
  Result := s.CanPop() and d.CanPush(s.Peek());
end;

constructor TTohGame.Create();
var
  i: Integer;
begin
  _numMoves := 0;
  for i := Low(_towers) to High(_towers) do
    _towers[i] := TTower.Create();
  _towers[1].Push(Red);
  _towers[1].Push(Green);
  _towers[1].Push(Blue);
end;

function TTohGame.GetNumMoves(): Integer;
begin
  Result := _numMoves;
end;

function TTohGame.GetTowers(): TTowerArray;
begin
  Result := _towers;
end;

function TTohGame.IsComplete(): Boolean;
begin
  Result := _towers[3].Height = 3;
end;

procedure TTohGame.MoveBlock(source: Integer; destination: Integer);
begin
  _towers[destination].Push(_towers[source].Pop());
  _numMoves := _numMoves + 1;
end;

end.
