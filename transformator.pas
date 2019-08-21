unit transformator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, dllform;
const
   keyprefix='tutr_';
type
  TfTransformator = class(TM2AddonForm)
    bTransform: TButton;
    ProgressBar1: TProgressBar;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    leCenterX: TLabeledEdit;
    leCenterY: TLabeledEdit;
    leAngle: TLabeledEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    leDX: TLabeledEdit;
    leDY: TLabeledEdit;
    cbRotate: TCheckBox;
    cbDelta: TCheckBox;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bTransformClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadParams;
    procedure SaveParams;
    procedure GetCoordsFromMap;
    procedure Rotate;
    procedure TransDelta;
    procedure RotatePoint(cx,cy,angle:double;var x,y:double);
    procedure DeltaPoint(cx,cy:double;var x,y:double);
    { Public declarations }
  end;

var
  fTransformator: TfTransformator;

function StrToAngle(s:string):double;
implementation
uses addn, Ingeo_TLB;
{$R *.dfm}

function StrToAngle(s:string):double;
var gg,mm,ss:integer;
    gs,ms,sss,ts:string;
    sig:boolean;
begin
  Result:=0;
  if s='' then exit;

  s:=Trim(s);
  if Pos('-',s)>0 then sig:=True else sig:=False;
  while not (s[1] in ['-','0'..'9']) do
  begin
    Delete(s,1,1);
    if s='' then exit;
  end;
  ts:='';
  while (s[1] in ['-','0'..'9']) do
  begin
    ts:=ts+s[1];
    Delete(s,1,1);
    if s='' then exit;
  end;
  gg:=Abs( StrToInt(ts));

  while not (s[1] in ['0'..'9']) do
  begin
    Delete(s,1,1);
    if s='' then exit;
  end;
  ts:='';
  while (s[1] in ['0'..'9']) do
  begin
    ts:=ts+s[1];
    Delete(s,1,1);
    if s='' then exit;
  end;
  mm:=StrToInt(ts);

  while not (s[1] in ['0'..'9']) do
  begin
    Delete(s,1,1);
    if s='' then exit;
  end;
  ts:='';
  while (s[1] in ['0'..'9']) do
  begin
    ts:=ts+s[1];
    Delete(s,1,1);
    if s='' then break;
  end;
  ss:=StrToInt(ts);
  if sig then
  begin
    Result:=-(gg+mm/60+ss/3600)/180*pi;
  end else
  begin
    Result:=(gg+mm/60+ss/3600)/180*pi;
  end;

end;

procedure TfTransformator.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveParams;
  action:=caFree;
end;

procedure TfTransformator.FormShow(Sender: TObject);
begin
  LoadParams;
end;

procedure TfTransformator.LoadParams;
begin
  leCenterX.Text:= gAddon2.UserProfile.Get(inupUser,'',keyprefix+ 'leCenterX',leCenterX.Text);
  leCenterY.Text:= gAddon2.UserProfile.Get(inupUser,'',keyprefix+'leCenterY',leCenterY.Text);
  leDX.Text:= gAddon2.UserProfile.Get(inupUser,'',keyprefix+'leDX',leDX.Text);
  leDY.Text:= gAddon2.UserProfile.Get(inupUser,'',keyprefix+'leDY',leDY.Text);
  leAngle.Text:= gAddon2.UserProfile.Get(inupUser,'',keyprefix+'leAngle',leAngle.Text);
  cbRotate.Checked:=StrToBool( gAddon2.UserProfile.Get(inupUser,'',keyprefix+'cbRotate',BoolToStr( cbRotate.Checked)));
  cbDelta.Checked:=StrToBool( gAddon2.UserProfile.Get(inupUser,'',keyprefix+'cbDelta',BoolToStr( cbDelta.Checked)));
end;

procedure TfTransformator.SaveParams;
begin
  gAddon2.UserProfile.Put(inupUser,'',keyprefix+ 'leCenterX',leCenterX.Text);
  gAddon2.UserProfile.Put(inupUser,'',keyprefix+'leCenterY',leCenterY.Text);
  gAddon2.UserProfile.Put(inupUser,'',keyprefix+'leDX',leDX.Text);
  gAddon2.UserProfile.Put(inupUser,'',keyprefix+'leDY',leDY.Text);
  gAddon2.UserProfile.Put(inupUser,'',keyprefix+'leAngle',leAngle.Text);
  gAddon2.UserProfile.Put(inupUser,'',keyprefix+'cbRotate',BoolToStr( cbRotate.Checked));
  gAddon2.UserProfile.Put(inupUser,'',keyprefix+'cbDelta',BoolToStr( cbDelta.Checked));

end;

procedure TfTransformator.Button1Click(Sender: TObject);
begin
  GetCoordsFromMap;
end;

procedure TfTransformator.GetCoordsFromMap;
var i:integer;
    mobjs:IIngeoMapObjects;
    mobj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    si,ci:integer;
    x,y,cnv:Double;
begin
  if gAddon2.Selection.Count=0 then exit;
//  mobjs:=gAddon2.
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[0]);
  for i:=0 to mobj.Shapes.Count-1 do
  begin
    shp:=mobj.Shapes[i];
    for si:=0 to shp.Contour.Count-1 do
    begin
      cntp:=shp.Contour[si];
      if cntp.VertexCount=1 then
      begin
        cntp.GetVertex(0,x,y,cnv);
        leCenterX.Text:=FloatToStr(x);
        leCenterY.Text:=FloatToStr(y);
        exit;
      end;
    end;
  end;
end;

procedure TfTransformator.bTransformClick(Sender: TObject);
begin
  Rotate;
//  if cbDelta.Checked then TransDelta;

end;

procedure TfTransformator.Rotate;
var cx,cy,angle,x,y,cnv,dcx,dcy:double;
    i,si,ci,vi:integer;
    mobjs:IIngeoMapObjects;
    mobj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
begin
  TryStrToFloat(leDX.Text,dcx);
  TryStrToFloat(leDY.Text,dcy);
  if (not TryStrToFloat(leCenterX.Text,cx))
     or (not TryStrToFloat(leCenterY.Text,cy))
  then
  begin
    ShowMessage('Неверный ввод чисел!');
    exit;
  end;
  mobjs:=gAddon2.ActiveDb.MapObjects;
//  mobjs.
  angle:=StrToAngle(leAngle.Text);
  for i:=0 to gAddon2.Selection.Count-1 do
  begin
    mobj:=mobjs.GetObject(gAddon2.Selection.IDs[i]);
    for si:=0 to mobj.Shapes.Count-1 do
    begin
      shp:=mobj.Shapes.Item[si];
      for ci:=0 to shp.Contour.Count-1 do
      begin
        cntp:=shp.Contour.Item[ci];
        for vi:=0 to cntp.VertexCount-1 do
        begin
          cntp.GetVertex(vi,x,y,cnv);
          if cbRotate.Checked then RotatePoint(cx,cy,angle,x,y);
          if cbDelta.Checked then DeltaPoint(dcx,dcy,x,y);
          cntp.SetVertex(vi,x,y,cnv);
        end; //vi
      end; //ci
    end;  //si
  end; //i
  mobjs.UpdateChanges;
end;

procedure TfTransformator.TransDelta;
begin

end;

procedure TfTransformator.RotatePoint(cx, cy, angle: double; var x,
  y: double);
var sina,cosa,nx,ny:double;

begin
  sina:=Sin(angle);
  cosa:=Cos(Angle);
  x:=x-cx;
  y:=y-cy;
  nx:=x*cosa-y*sina;
  ny:=x*sina+y*cosa;
  x:=nx+cx;
  y:=ny+cy;
end;

procedure TfTransformator.DeltaPoint(cx, cy: double; var x, y: double);
begin
  x:=x+cx;
  y:=y+cy;
end;

end.
