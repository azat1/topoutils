unit contourorient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DLLForm, Ingeo_TLB;

type
  TfContourOrient = class(TM2AddonForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure MakeOrient;
    procedure ReverseContour(cntp:IIngeoContourPart);
    function CalcSquare(cntp:IIngeoContourPart):double;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fContourOrient: TfContourOrient;

implementation
uses addn;
{$R *.dfm}

procedure TfContourOrient.Button1Click(Sender: TObject);
begin
  MakeOrient;

end;

procedure TfContourOrient.Button2Click(Sender: TObject);
begin
  Close;
end;

function TfContourOrient.CalcSquare(cntp: IIngeoContourPart): double;
var r1,r2,s,x,y,cv,x1,y1,x2,y2:double;

  i,i1,i2: Integer;
begin
  s:=0;
  for i := 0 to cntp.VertexCount - 1 do
  begin
    i1:=i-1;
    if i1<0 then
        i1:=cntp.VertexCount-1;
    i2:=i+1;
    if i2=cntp.VertexCount then
      i2:=0;
    cntp.GetVertex(i1,x1,y1,cv);
    cntp.GetVertex(i2,x2,y2,cv);
    cntp.GetVertex(i,x,y,cv);
    r1:=y2-y1;
    s:=s+r1*x1;
  end;
  Result:=s;

end;

procedure TfContourOrient.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfContourOrient.MakeOrient;
var mobjs:IIngeoMapObjects;
   obj:IIngeoMapObject;
  i: Integer;
  s: Integer;
  c: Integer;
  shp:IIngeoShape;
  cntp:IIngeoContourPart;
  rs:double;
begin
  if gAddon2.Selection.Count=0   then
  begin
    ShowMessage('Не выделены объекты!');
    exit;
  end;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  for i := 0 to gAddon2.Selection.Count - 1 do
  begin
    obj:=mobjs.GetObject(gaddon2.Selection.IDs[i]);
    for s := 0 to obj.Shapes.Count - 1 do
    begin

      if obj.Shapes.Item[s].DefineGeometry then
      begin
        shp:=obj.Shapes.Item[s];
        for c := 0 to shp.Contour.Count - 1 do
        begin
          cntp:=shp.Contour.Item[c];
          rs:=CalcSquare(cntp);
          if (rs<0) and (RadioGroup1.ItemIndex=0) then
          begin
            ReverseContour(cntp);
          end;
          if (rs>0) and (RadioGroup1.ItemIndex=1) then
          begin
            ReverseContour(cntp);
          end;
        end;
      end;
    end;
  end;
  mobjs.UpdateChanges;
  ShowMessage('Выполнено!');
end;

procedure TfContourOrient.ReverseContour(cntp: IIngeoContourPart);
var cntp2:IIngeoContourPart;
    x,y:array of double;
    cv:double;
  i,c: Integer;
begin
  c:=cntp.VertexCount;
  SetLength(x,c);
  SetLength(y,c);
  for i := 0 to c - 1 do
  begin
    cntp.GetVertex(i,x[i],y[i],cv);
  end;
  cntp.Clear;
  for i :=c-1  downto 0 do
  begin
    cntp.InsertVertex(-1,x[i],y[i],0);
  end;
  x:=nil;y:=nil;
end;

end.
