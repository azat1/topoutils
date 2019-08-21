unit decurve;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, M2Addon,M2AddonD,Ingeo_TLB,InScripting_TLB, DllForm, StdCtrls,
  ComCtrls;

type
  TM3x3=array [1..3,1..3] of extended;
  PM3x3=^TM3x3;

  TfDeCurve = class(TM2AddonForm)
    Button1: TButton;
    Edit1: TEdit;
    udStep: TUpDown;
    Label1: TLabel;
    Button2: TButton;
    bFastMake: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bFastMakeClick(Sender: TObject);
  private
    asin:array [-1200..1200] of double;
    acos:array [-1200..1200] of double;
//    fsin:array [-1200..1200] of double;
//    fcos:array [-1200..1200] of double;
    mobjs:IIngeoMapObjects;
    deltaang:integer;
    { Private declarations }
    procedure Operate;
    procedure Precalculate;
    procedure DecurveObject(objid:string);
    procedure DecurveContour(cntp:IIngeoContourPart);
    procedure DecurveContour2(cntp:IIngeoContourPart);
    procedure Curve2Lines(cntp:IIngeoContourPart;vi:integer;lx,ly,x,y,cv:double);
    procedure Curve2Lines2(cntp:IIngeoContourPart;vi:integer;lx,ly,x,y,cv:double);
    procedure CalculateCircle(lx,ly,x,y,cv:double;var f1,f2,r,x0,y0:double);
    procedure Decurve2;
    procedure DecurveFast;
    procedure Curve2Lines2Fast(cntp: IIngeoContourPart; vi: integer; lx, ly, x, y, cv: double);
    procedure DecurveContour2F(cntp: IIngeoContourPart);

//    function FSin(f:double):double;

  public
    { Public declarations }
  end;

var
  fDeCurve: TfDeCurve;

procedure FindCircle(x1,y1,x2,y2,x3,y3:double;var x0,y0,r:double);
function M3x3Opred(m:TM3x3):extended;
function M3x3(a11,a21,a31,a12,a22,a32,a13,a23,a33:double):TM3x3;
function CalcAngle(x1,y1,x2,y2:double):double;
function RoundUp(f:double;step:integer):integer;
function RoundDown(f:double;step:integer):integer;

implementation
uses addn, math;
{$R *.dfm}
function RoundUp(f:double;step:integer):integer;
var ff:integer;
begin
  ff:=Round(f);
  ff:=(ff div step)*step;
  if ff<f then ff:=ff+step;
  REsult:=ff;
end;

function RoundDown(f:double;step:integer):integer;
var ff:integer;
begin
  ff:=Round(f);
  ff:=(ff div step)*step;
  if ff>f then ff:=ff-step;
  REsult:=ff;
end;

function CalcAngle(x1,y1,x2,y2:double):double;
begin
  Result:=ArcTan2(y2-y1,x2-x1);
  if Result<0 then Result:=Result+2*pi;
end;

function M3x3(a11,a21,a31,a12,a22,a32,a13,a23,a33:double):TM3x3;
begin
    Result[1,1]:=a11;
    Result[2,1]:=a21;
    Result[3,1]:=a31;
    Result[1,2]:=a12;
    Result[2,2]:=a22;
    Result[3,2]:=a32;
    Result[1,3]:=a13;
    Result[2,3]:=a23;
    Result[3,3]:=a33;
end;

function M3x3Opred(m:TM3x3):extended;
begin
    // 11 21 31
    // 12 22 32
    // 13 23 33
    Result:=(m[1,1]*m[2,2]*m[3,3]+m[3,1]*m[1,2]*m[2,3]+m[1,3]*m[2,1]*m[3,2])-
            (m[3,1]*m[2,2]*m[1,3]+m[1,1]*m[3,2]*m[2,3]+m[3,3]*m[1,2]*m[2,1]);
end;

procedure FindCircle(x1,y1,x2,y2,x3,y3:double;var x0,y0,r:double);
var a,b,c,k1,k2,sx1,sx2,sx3:extended;
begin
    sx1:=SQR(X1)+SQR(y1);
    sx2:=SQR(X2)+SQR(y2);
    sx3:=SQR(X3)+SQR(y3);
    k1:=1.0/M3x3Opred(M3x3(x1,y1,1,x2,y2,1,x3,y3,1));
    a:=-M3x3Opred(M3x3(sx1,y1,1,
                       sx2,y2,1,
                       sx3,y3,1))*k1;
    b:=M3x3Opred(M3x3(sx1,x1,1,
                      sx2,x2,1,
                      sx3,x3,1))*k1;
    c:=-M3x3Opred(M3x3(sx1,x1,y1,
                       sx2,x2,y2,
                       sx3,x3,y3))*k1;
    r:=SQRT(Abs(SQR(a)+SQR(b)-4.0*c))/2.0;
    x0:=-a/2;
    y0:=-b/2;
//    r:=SQRT(SQR(x1-x0)+SQR(y1-y0));
end;

procedure TfDeCurve.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfDeCurve.bFastMakeClick(Sender: TObject);
begin
  DecurveFast;
end;

procedure TfDeCurve.Button1Click(Sender: TObject);
begin
  Operate;
end;

procedure TfDeCurve.Operate;
var i:integer;
    objid:string;
begin
  PreCalculate;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  for i:=0 to gAddon2.Selection.Count-1 do
  begin
    DecurveObject(gAddon2.Selection.IDs[i]);
  end;
  mobjs.UpdateChanges;
end;

procedure TfDeCurve.Precalculate;
var i:integer;
begin
  for i:=-1200 to 1200 do
  begin
    asin[i]:=sin(i/100);
    acos[i]:=cos(i/100);
  end;
  deltaang:=Round(628/(360.0/udStep.Position));
end;

procedure TfDeCurve.DecurveObject(objid: string);
var obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    si,ci:integer;
begin
  obj:=mobjs.GetObject(objid);
  for si:=0 to obj.Shapes.Count-1 do
  begin
    shp:=obj.Shapes.Item[si];
    for ci:=0 to shp.Contour.Count-1 do
    begin
      cntp:=shp.Contour.Item[ci];
      DeCurveContour(cntp);
    end;
  end;
end;

procedure TfDeCurve.Decurve2;
var obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    si,ci:integer;
  oi: Integer;
begin
  mobjs:=gAddon2.ActiveDb.MapObjects;
  for oi := 0 to gAddon2.Selection.Count - 1 do
  begin
    obj:=mobjs.GetObject(gAddon2.Selection.IDs[oi]);
    for si:=0 to obj.Shapes.Count-1 do
    begin
      shp:=obj.Shapes.Item[si];
      for ci:=0 to shp.Contour.Count-1 do
      begin
        cntp:=shp.Contour.Item[ci];
        DeCurveContour2(cntp);
      end;
    end;
  end;
  mobjs.UpdateChanges;
//  gAddon2.ActiveDb.MapObjects.UpdateChanges;
end;

procedure TfDeCurve.DecurveContour(cntp: IIngeoContourPart);
var vi:integer;
    lx,ly,x,y,cv,ccv:double;
    flag:boolean;
begin
  vi:=0;
  flag:=False;
  while vi<cntp.VertexCount do
  begin
    cntp.GetVertex(vi,x,y,cv);
    if (vi=0) and (cv<>0) then flag:=True;
    if (cv<>0) and (vi<>0) then
    begin
      Curve2Lines(cntp,vi,lx,ly,x,y,cv);
//      continue;
    end;
    lx:=x;
    ly:=y;
    inc(vi);
  end;
  if flag  and cntp.Closed then
  begin
    cntp.GetVertex(0,x,y,cv);
    cntp.GetVertex(cntp.VertexCount-1,lx,ly,ccv);
    Curve2Lines(cntp,cntp.VertexCount-1,lx,ly,x,y,cv);
  end;
end;

procedure TfDeCurve.DecurveContour2(cntp: IIngeoContourPart);
var vi:integer;
    lx,ly,x,y,cv,ccv:double;
    flag:boolean;
begin
  vi:=0;
  flag:=False;
  while vi<cntp.VertexCount do
  begin
    cntp.GetVertex(vi,x,y,cv);
    if (vi=0) and (cv<>0) then flag:=True;
    if (cv<>0) and (vi<>0) then
    begin
      Curve2Lines2(cntp,vi,lx,ly,x,y,cv);
//      continue;
    end;
    lx:=x;
    ly:=y;
    inc(vi);
  end;
  if flag  and cntp.Closed then
  begin
    cntp.GetVertex(0,x,y,cv);
    cntp.GetVertex(cntp.VertexCount-1,lx,ly,ccv);
    Curve2Lines2(cntp,cntp.VertexCount-1,lx,ly,x,y,cv);
  end;
end;

procedure TfDeCurve.DecurveContour2F(cntp: IIngeoContourPart);
var vi:integer;
    lx,ly,x,y,cv,ccv:double;
    flag:boolean;
begin
  vi:=0;
  flag:=False;
  while vi<cntp.VertexCount do
  begin
    cntp.GetVertex(vi,x,y,cv);
    if (vi=0) and (cv<>0) then flag:=True;
    if (cv<>0) and (vi<>0) then
    begin
      Curve2Lines2Fast(cntp,vi,lx,ly,x,y,cv);
//      continue;
    end;
    lx:=x;
    ly:=y;
    inc(vi);
  end;
  if flag  and cntp.Closed then
  begin
    cntp.GetVertex(0,x,y,cv);
    cntp.GetVertex(cntp.VertexCount-1,lx,ly,ccv);
    Curve2Lines2Fast(cntp,cntp.VertexCount-1,lx,ly,x,y,cv);
  end;
end;

procedure TfDeCurve.DecurveFast;
var obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    si,ci:integer;
  oi: Integer;
begin
  mobjs:=gAddon2.ActiveDb.MapObjects;
  for oi := 0 to gAddon2.Selection.Count - 1 do
  begin
    obj:=mobjs.GetObject(gAddon2.Selection.IDs[oi]);
    for si:=0 to obj.Shapes.Count-1 do
    begin
      shp:=obj.Shapes.Item[si];
      for ci:=0 to shp.Contour.Count-1 do
      begin
        cntp:=shp.Contour.Item[ci];
        DeCurveContour2F(cntp);
      end;
    end;
  end;
  mobjs.UpdateChanges;
//  gAddon2.ActiveDb.MapObjects.UpdateChanges;
end;

procedure TfDeCurve.Curve2Lines(cntp: IIngeoContourPart; vi: integer; lx, ly, x,
  y, cv: double);
var f1,f2,r,x0,y0,nx,ny:double;
    cntrl,ang1,ang2,ang,da:integer;
begin
  cntp.SetVertex(vi,x,y,0);
  CalculateCircle(lx,ly,x,y,cv,f1,f2,r,x0,y0);

  if (sin(deltaang/100)*r)>SQRT(SQR(lx-x)+SQR(ly-y)) then
  begin
    cntp.InsertVertex(vi,lx,ly,0);
    exit;
  end;
  if cv>0 then
  begin
    if f2<f1 then f2:=f2+Pi*2;

    ang1:=RoundUp(f1*100,deltaang);
    ang2:=RoundDown(f2*100,deltaang);
    ang:=ang1;
    da:=deltaang;
  end else
  begin
    if f2>f1 then f2:=f2-Pi*2;
    ang1:=RoundDown(f1*100,deltaang);
    ang2:=RoundUp(f2*100,deltaang);
    ang:=ang1;
    da:=-deltaang;
  end;
  ang:=ang1;
  cntrl:=0;
  while True do
  begin
    if da>0 then
    begin
      if ang>ang2 then break;
    end else
    begin
      if ang<ang2 then break;
    end;
    nx:=x0+acos[ang]*r;
    ny:=y0+asin[ang]*r;
    cntp.InsertVertex(vi,nx,ny,0);
    inc(vi);

    ang:=ang+da;
    inc(cntrl);
    if cntrl>1000 then
    begin
      ShowMessage('ddd');
      exit;
    end;
{    if ang<0 then
    begin
      ang:=ang+628;
      ang:=RoundDown(ang,deltaang)
    end;
    if ang>628 then
    begin
      ang:=ang-628;
      ang:=RoundUp(ang,deltaang)
    end;}

  end;
end;

procedure TfDeCurve.Curve2Lines2(cntp: IIngeoContourPart; vi: integer; lx, ly, x, y, cv: double);
var l,l2,r,x0,y0:double;
    t,wx,wy,fi1,fi2,c,vx,vy,px,py:double;
    x2,y2,cv2:double;
  i,n: Integer;
  cn,sign: integer;
begin
//  cntp.SetVertex(vi-1,lx,ly,0);
  cntp.DeleteVertex(vi);
  cntp.InsertVertex(vi,x,y,0);
//  cntp.SetVertex(vi,x+5,y,0);
//  cntp.GetVertex(vi-1,x2,y2,cv2);
//
//  cntp.GetVertex(vi,x2,y2,cv2);

  l:=SQRT(SQR(lx-x)+SQR(ly-y));
  if l<1e-6 then exit;
  if abs(cv)<1e-6 then
    exit;
  r:=abs(l*(1+cv*cv)/4/cv);
  vx:=(x+lx)/2;
  vy:=(y+ly)/2;
  vx:=vx+(y-ly)/2*cv;// (x+lx)/2;
  vy:=vy-(x-lx)/2*cv;
  if cv>0 then
  begin
    vx:=vx-(y-ly)/l*r;// (x+lx)/2;
    vy:=vy+(x-lx)/l*r;
  end else
  begin
    vx:=vx+(y-ly)/l*r;// (x+lx)/2;
    vy:=vy-(x-lx)/l*r;
  end;
  c:=0;
  x0:=vx;//+ (y-ly)*c;    //-y
  y0:=vy;//+ (lx-x)*c;    //x
  n:=Round(2*pi*r/0.2);
  if n<6 then
    n:=6;
  if n>100 then
    n:=100;
  fi1:=CalcAngle(x0,y0,lx,ly);
  fi2:=CalcAngle(x0,y0,x,y);
  if fi2<fi1 then
    fi2:=fi2+2*pi;
  if cv>0 then
  begin
    cn:=Round(int((fi2-fi1)/ (2*pi/n)));
    sign:=1;
  end else
  begin
    cn:=Round(int((2*pi-(fi2-fi1))/ (2*pi/n)));
    sign:=-1;
  end;
  t:=2*r*sin(180/n);
  for i := 1 to cn  do
  begin
    wx:=x0+r*cos(fi1+2*pi*i/n*sign);
    wy:=y0+r*sin(fi1+2*pi*i/n*sign);
    cntp.InsertVertex(vi,wx,wy,0);
    inc(vi);
  end;
end;

procedure TfDeCurve.Curve2Lines2Fast(cntp: IIngeoContourPart; vi: integer; lx, ly, x, y, cv: double);
var l,l2,r,x0,y0:double;
    t,wx,wy,fi1,fi2,c,vx,vy,px,py:double;
    x2,y2,cv2:double;
  i,n: Integer;
  cn,sign: integer;
begin
//  cntp.SetVertex(vi-1,lx,ly,0);
  cntp.DeleteVertex(vi);
  cntp.InsertVertex(vi,x,y,0);
//  cntp.SetVertex(vi,x+5,y,0);
//  cntp.GetVertex(vi-1,x2,y2,cv2);
//
//  cntp.GetVertex(vi,x2,y2,cv2);

  l:=SQRT(SQR(lx-x)+SQR(ly-y));
  if l<1e-6 then exit;
  if abs(cv)<1e-6 then
    exit;
  r:=abs(l*(1+cv*cv)/4/cv);
  vx:=(x+lx)/2;
  vy:=(y+ly)/2;
  vx:=vx+(y-ly)/2*cv;// (x+lx)/2;
  vy:=vy-(x-lx)/2*cv;
  if cv>0 then
  begin
    vx:=vx-(y-ly)/l*r;// (x+lx)/2;
    vy:=vy+(x-lx)/l*r;
  end else
  begin
    vx:=vx+(y-ly)/l*r;// (x+lx)/2;
    vy:=vy-(x-lx)/l*r;
  end;
  c:=0;
  x0:=vx;//+ (y-ly)*c;    //-y
  y0:=vy;//+ (lx-x)*c;    //x
  n:=Round(2*pi*r/0.2);
  if n<6 then
    n:=6;
  if n>10 then
    n:=12;
  fi1:=CalcAngle(x0,y0,lx,ly);
  fi2:=CalcAngle(x0,y0,x,y);
  if fi2<fi1 then
    fi2:=fi2+2*pi;
  if cv>0 then
  begin
    cn:=Round(int((fi2-fi1)/ (2*pi/n)));
    sign:=1;
  end else
  begin
    cn:=Round(int((2*pi-(fi2-fi1))/ (2*pi/n)));
    sign:=-1;
  end;
  t:=2*r*sin(180/n);
  for i := 1 to cn  do
  begin
    wx:=x0+r*cos(fi1+2*pi*i/n*sign);
    wy:=y0+r*sin(fi1+2*pi*i/n*sign);
    cntp.InsertVertex(vi,wx,wy,0);
    inc(vi);
  end;
end;

procedure TfDeCurve.Button2Click(Sender: TObject);
begin
  Decurve2;
end;

procedure TfDeCurve.CalculateCircle(lx, ly, x, y, cv: double; var f1, f2, r, x0,
  y0: double);
var l,a,b,c,d,s:extended;
    vx,vy,v2x,v2y,x3,y3,v3x,v3y:double;
begin
  l:=SQRT(SQR(lx-x)+SQR(ly-y));
  r:=l/2/cv;
  vx:=(x-lx)/2;
  vy:=(y-ly)/2;
  x3:=(lx+x)/2;
  y3:=(ly+y)/2;
  if cv>0 then
  begin
    v3x:=-vy;
    v3y:=vx;
    v2x:=-vy*(-cv);
    v2y:=vx*(-cv);
  end
  else
  begin
    v3x:=vy;
    v3y:=-vx;
    v2x:=vy*(cv);
    v2y:=-vx*(cv);
  end;
  x3:=x3+v2x;
  y3:=y3+v2y;
  a:=SQRT(SQR(lx-x)+SQR(ly-y));
  b:=SQRT(SQR(lx-x3)+SQR(ly-y3));
  c:=SQRT(SQR(x-x3)+SQR(y-y3));
  s:=abs(M3x3Opred(M3x3(lx,ly,1,x,y,1,x3,y3,1)))/2;
  r:=(a*b*c)/(4*s);
  x0:=x3+v3x/l*r*2;
  y0:=y3+v3y/l*r*2;
//  FindCircle(lx,ly,x3,y3,x,y,x0,y0,r);
//  r:=SQRT(SQR(lx-x0)+SQR(ly-y0));
//  f1:=ArcTan2(y,x);
  f1:=CalcAngle(x0,y0,lx,ly);
  f2:=CalcAngle(x0,y0,x,y);

end;

end.
