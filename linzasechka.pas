unit linzasechka;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DllForm, linzmapeditor, ExtCtrls;

type
  TfLinZasechka = class(TM2AddonForm)
    sgData: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure sgDataClick(Sender: TObject);
    procedure sgDataDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    editor:TLZPointSelector;
    px,py,pl:array [0..100] of double;
    pcount:integer;
    rx,ry:array [0..10000] of double;
    ri1,ri2:array [0..10000] of integer;
    rcount:integer;
    procedure RemoveEditor;
    procedure AddEditor;
    procedure Calculate;
    procedure LoadPoints;
    function CalcDirection(i1,i2:integer):integer;
    procedure CalcPos(i1,i2:integer;var cx,cy:double);
    procedure AddCalculation(i1,i2:integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLinZasechka: TfLinZasechka;

implementation
uses addn;
{$R *.dfm}

procedure TfLinZasechka.AddCalculation(i1, i2: integer);
begin
  CalcPos(i1,i2,rx[rcount],ry[rcount]);
  ri1[rcount]:=i1;
  ri2[rcount]:=i2;
  inc(rcount);
end;

procedure TfLinZasechka.AddEditor;
begin
  editor:=TLZPointSelector.Create(gAddon,self);
  gAddon.MapView.AddEditor(editor.IEditor);
end;

procedure TfLinZasechka.Button1Click(Sender: TObject);
var dir:integer;
  i: Integer;
  j: Integer;
begin
  if pcount<3 then
  begin
    ShowMessage('Недостаточно измерений ! (меньше 3)');
    exit;
  end;
  Calculate;
end;

function TfLinZasechka.CalcDirection(i1, i2: integer): integer;
begin

end;

procedure TfLinZasechka.CalcPos(i1, i2: integer; var cx, cy: double);
begin

end;

procedure TfLinZasechka.Calculate;
var c1,c2:integer;
    cx1,cy1,cx2,cy2,l1,l2:double;
  i: Integer;
  j: Integer;
  maxerror:double;
begin
  maxerror:=5.0;
  LoadPoints;
  rcount:=0;
  AddCalculation(0,1);
  repeat
  CalcPos(1,2,cx1,cy1);
  l1:=SQRT(Sqr(cx1-rx[0])+Sqr(cy1-ry[0]));
  CalcPos(2,1,cx2,cy2);
  l2:=SQRT(Sqr(cx2-rx[0])+Sqr(cy2-ry[0]));
  if l1<l2 then
  begin
    if l1>error then
    begin
      rcount:=0;
      AddCalculation(1,0);
      continue;
    end else
    begin
      break;
    end;
  end;
  until False;
  for i := 0 to pCount - 1 do
    for j := i+1 to pCount - 1 do
    begin
      CalcPos(i,j,cx1,cy1);
      CalcPos(j,i,cx2,cy2);
      l1:=SQRT(Sqr(cx1-rx[0])+Sqr(cy1-ry[0]));
      l2:=SQRT(Sqr(cx2-rx[0])+Sqr(cy2-ry[0]));
      if l1<l2 then
      begin
        AddCalculation(i,j);
      end else AddCalculation(j,i);
    end;


end;

procedure TfLinZasechka.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  RemoveEditor;
end;

procedure TfLinZasechka.FormCreate(Sender: TObject);
begin
  AddEditor;
end;

procedure TfLinZasechka.FormShow(Sender: TObject);
begin
  sgData.ColWidths[0]:=20;
  sgData.ColWidths[1]:=100;
  sgData.ColWidths[2]:=100;
  sgData.ColWidths[3]:=60;
  sgData.Cells[0,0]:='ВЫбор';
  sgData.Cells[1,0]:='X';
  sgData.Cells[2,0]:='Y';
  sgData.Cells[3,0]:='Длина';
end;

procedure TfLinZasechka.LoadPoints;
var
  i: Integer;
  x,y,l:double;
begin
  pcount:=0;
  for i := 1 to sgData.RowCount - 1 do
  begin
    if (TryStrToFloat(sgData.Cells[1,i],px[pcount])) and
       (TryStrToFloat(sgData.Cells[2,i],py[pcount])) and
       (TryStrToFloat(sgData.Cells[3,i],pl[pcount])) then
       begin
         inc(pcount);
       end;
  end;
end;

procedure TfLinZasechka.RemoveEditor;
begin
  gaddon.MapView.RemoveEditor(editor.IEditor);
  editor:=nil;
end;

procedure TfLinZasechka.sgDataClick(Sender: TObject);
begin
  if sgData.Col=0 then
  begin
    editor.pointselecting:=True;
    Hide;
  end;
end;

procedure TfLinZasechka.sgDataDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (Acol=0) and (arow>0) then
  begin
    sgData.Canvas.Draw(RECT.Left+1,Rect.Top+1,Image1.Picture.Bitmap);
  end;
end;

end.
