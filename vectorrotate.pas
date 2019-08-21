unit vectorrotate;
interface
uses Ingeo_TLB, Forms, Dialogs;

type
  TVectorRotater=class
    app:IIngeoApplication;
    constructor Create(app:IIngeoApplication);
    procedure RotateSelected(angle:double);
    procedure RotateOneObject(mobj:IIngeoMapObject;dx,dy:double);
    procedure RotateSelectedToFixedangle(angle:double);
  private
    procedure RotateToFixedangle(angle: double);
    procedure RotateOneObjectFixedAngle(mobj: IIngeoMapObject; dx, dy: double);
  end;
procedure StartVectorRotate(app:IIngeoApplication);

implementation

uses vectorrotaterform;

procedure StartVectorRotate(app:IIngeoApplication);
var tvr:TVectorRotater;
  frm: TfVectorRotater;
begin
  tvr:=TVectorRotater.Create(app);
  frm:=TfVectorRotater.Create(nil);
  frm.vectorrotater:=tvr;
  frm.ShowModal;
  tvr.Free;
  frm.Free;
end;

{ TVectorRotater }

constructor TVectorRotater.Create(app: IIngeoApplication);
begin
  self.app:=app;
end;

procedure TVectorRotater.RotateOneObject(mobj: IIngeoMapObject; dx, dy: double);
var
  si: Integer;
  shp: IIngeoShape;
  ci: Integer;
  cntp: IIngeoContourPart;
  x1,y1,x2,y2,cv,cv2: double;
  ll: double;
  xx: Double;
  yy: Double;
begin
  for si := 0 to mobj.Shapes.Count - 1 do
  begin
    shp:=mobj.Shapes[si];
    if shp.Contour.Perimeter=0 then
      continue;
    if shp.Contour.Square>0 then
      continue;
    if shp.Contour.Count>1 then
      continue;
    for ci := 0 to shp.Contour.Count - 1 do
    begin
      cntp:=shp.Contour[ci];
      if cntp.VertexCount<>2 then
        continue;
      cntp.GetVertex(0,x1, y1, cv);
      cntp.GetVertex(1,x2, y2, cv2);
      ll:=Sqrt(sqr(x1-x2)+sqr(y1-y2));
      xx:=x1+ll*dx;
      yy:=y1+ll*dy;
      cntp.SetVertex(1,xx,yy,0);
    end;

  end;

end;

procedure TVectorRotater.RotateOneObjectFixedAngle(mobj: IIngeoMapObject; dx,dy: double);
var
  si: Integer;
  shp: IIngeoShape;
  ci: Integer;
  cntp: IIngeoContourPart;
  x1,y1,x2,y2,cv,cv2: double;
  ll: double;
  xx: Double;
  yy: Double;
begin
  for si := 0 to mobj.Shapes.Count - 1 do
  begin
    shp:=mobj.Shapes[si];
    if shp.Contour.Perimeter=0 then
      continue;
    if shp.Contour.Square>0 then
      continue;
    if shp.Contour.Count>1 then
      continue;
    for ci := 0 to shp.Contour.Count - 1 do
    begin
      cntp:=shp.Contour[ci];
      if cntp.VertexCount<>2 then
        continue;
      cntp.GetVertex(0,x1, y1, cv);
      cntp.GetVertex(1,x2, y2, cv2);
      ll:=Sqrt(sqr(x1-x2)+sqr(y1-y2));
      xx:=x1+ll*dx;
      yy:=y1+ll*dy;
      cntp.SetVertex(1,xx,yy,0);
    end;

  end;

end;

procedure TVectorRotater.RotateSelected(angle: double);
var angr:double;
    dx,dy:double;
  i: Integer;
  mobjs:IIngeoMapObjects;
  mobj: IIngeoMapObject;
begin
  if app.Selection.Count=0 then
  begin
    ShowMessage('Не выделено ни одного объекта!');
    exit;
  end;
  angr:=angle/180*Pi;
  dx:=cos(angr);
  dy:=sin(angr);
  mobjs:=app.ActiveDb.MapObjects;
  for i := 0 to app.Selection.Count - 1 do
  begin
    mobj:=mobjs.GetObject(app.Selection.IDs[i]);
    RotateOneObject(mobj,dx,dy);
  end;
  mobjs.UpdateChanges;
end;

procedure TVectorRotater.RotateSelectedToFixedangle(angle: double);
begin

end;

procedure TVectorRotater.RotateToFixedangle(angle: double);
begin

end;

end.
