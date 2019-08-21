unit fcoordeditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfCoordEdit = class(TForm)
    Label1: TLabel;
    eName: TEdit;
    Label2: TLabel;
    cbDatumType: TComboBox;
    Label3: TLabel;
    eCM: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    eFNorth: TEdit;
    eFEast: TEdit;
    Button1: TButton;
    Button2: TButton;
    eScale: TEdit;
    Label6: TLabel;
    lDD: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure eCMExit(Sender: TObject);
  private
    procedure FormatAngle;
    function CheckCorrect:boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCoordEdit: TfCoordEdit;
function GetInteger(var s:string):integer;
function GetFloat(var s:string):double;
function GetFloatP(var s:string):double;
function StrToAngle(s:string):double;
function AngleToStr(ang:extended):string;
function AngleToStrF(ang:extended;f:integer):string;
implementation

{$R *.dfm}

function AngleToStr(ang:extended):string;
var g,m,s,t:extended;
begin
  ang:=ang/PI*180;
  g:=Int(ang);
  t:=Frac(ang)*3600;
  m:=Int(t/60);
  s:=t-m*60;
  REsult:=Format('%.0f %.0f %.4f',[g,m,s]);
end;

function AngleToStrF(ang:extended;f:integer):string;
var g,m,s,t:extended;
begin
  ang:=ang/PI*180;
  g:=Int(ang);
  t:=Frac(ang)*3600;
  m:=Int(t/60);
  s:=t-m*60;
  case f of
  0:REsult:=Format('%.7f',[ang]);
  1:REsult:=Format('%.0f %.7f',[g,m+s/60]);
  2:REsult:=Format('%.0f %.0f %.4f',[g,m,s]);
  end;
//  REsult:=Format('%.0f %.0f %.4f',[g,m,s]);
end;

function GetInteger(var s:string):integer;
var ts:string;
begin
  while (Length(s)>0) and (not(s[1] in ['0'..'9','-'])) do
    Delete(s,1,1);
  ts:='';
  while (Length(s)>0) and (s[1] in ['0'..'9','-']) do
  begin
    ts:=ts+s[1];
    Delete(s,1,1);
  end;
  Result:=0;
  TryStrToInt(ts,Result);
end;

function GetFloat(var s:string):double;
var ts:string;
begin
  while (Length(s)>0) and (not(s[1] in ['0'..'9','-'])) do
    Delete(s,1,1);
  ts:='';
  while (Length(s)>0) and (s[1] in ['0'..'9','-',',']) do
  begin
    ts:=ts+s[1];
    Delete(s,1,1);
  end;
  Result:=0;
  TryStrToFloat(ts,Result);
end;

function GetFloatP(var s:string):double;
var ts:string;
    c:Char;
begin
  c:=DecimalSeparator;
  while (Length(s)>0) and (not(s[1] in ['0'..'9','-'])) do
    Delete(s,1,1);
  ts:='';
  while (Length(s)>0) and (s[1] in ['0'..'9','-','.']) do
  begin
    if s[1]='.' then ts:=ts+',' else
      ts:=ts+s[1];
    Delete(s,1,1);
  end;
  Result:=0;
  TryStrToFloat(ts,Result);
end;

function StrToAngle(s:string):double;
var
    g,m,ss:double;
begin
//  s:=eCM.Text;
  if s='' then
  begin
    raise EConvertError.Create('Не угол!');
//    RaiseException();
  end;
  g:=GetInteger(s);
  m:=GetInteger(s);
  ss:=GetFloat(s);
  Result:=(g+m/60+ss/3600)/180*pi;
end;


{ TfCoordEdit }

procedure TfCoordEdit.Button1Click(Sender: TObject);
begin
  if not CheckCorrect then
  begin
    ShowMessage('Неверный ввод параметров!');
    ModalResult:=mrNone;
  end;
end;

function TfCoordEdit.CheckCorrect: boolean;
var
  tmp: double;
begin
  Result:=True;
  if eName.Text='' then
     Result:=False;
  if cbDatumType.ItemIndex=-1  then
     Result:=False;
  if eCM.Text=''  then
     Result:=False;
  if not TryStrToFloat(eFNorth.Text,tmp)  then
     Result:=False;
  if not TryStrToFloat(eFEast.Text,tmp)  then
     Result:=False;
  if not TryStrToFloat(eScale.Text,tmp)  then
     Result:=False;


end;

procedure TfCoordEdit.eCMExit(Sender: TObject);
begin
  FormatAngle;
end;

procedure TfCoordEdit.FormatAngle;
var s:string;
    g,m,ss:double;
begin
  s:=eCM.Text;
  g:=GetInteger(s);
  m:=GetInteger(s);
  ss:=GetFloat(s);
  eCM.Text:=Format('%.0f %.0f''%.2f"',[g,m,ss]);
end;

end.
