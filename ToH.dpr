program ToH;



{$R 'ToHResource.res' 'ToHResource.rc'}

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  ToHClasses in 'ToHClasses.pas',
  HIScore in 'HIScore.pas' {HiScoreForm},
  NewHiScore in 'NewHiScore.pas' {NewHiScoreForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(THiScoreForm, HiScoreForm);
  Application.CreateForm(TNewHiScoreForm, NewHiScoreForm);
  Application.Run;
end.
