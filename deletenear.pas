unit deletenear;

interface
uses Classes,SysUtils,Ingeo_TLB,InScripting_TLB;
type
  TDeleteNear=class
    public
      app:IIngeoApplication;
      mobjs:IIngeoMapObjects;
      constructor Create(app:IIngeoApplication);
      procedure DeleteNear;
      procedure DeleteNearcontour(cntr: IIngeoContour);
      function LineLength(x1,y1,x2,y2:double):double;
  end;
  procedure StartDeleteNear(app:IIngeoApplication);
implementation

  procedure StartDeleteNear(app:IIngeoApplication);
  var dn:TDeleteNear;
  begin
    dn:=TDeleteNear.Create(app);
    dn.DeleteNear;
    dn.Free;
  end;
{ TDeleteNear }

constructor TDeleteNear.Create(app: IIngeoApplication);
begin
  self.app:=app;
end;

procedure TDeleteNear.DeleteNear;
var
  i: Integer;
  mobj: IIngeoMapObject;
  si: Integer;
begin
  mobjs:=app.ActiveDb.MapObjects;
  for i := 0 to app.Selection.Count - 1 do
  begin
    mobj:=mobjs.GetObject(app.Selection.IDs[i]);
    for si := 0 to mobj.shapes.Count - 1 do
    begin
      if mobj.Shapes[si].DefineGeometry then
      begin
        DeleteNearContour(mobj.Shapes[si].Contour);
      end;
    end;

  end;
  mobjs.UpdateChanges;
end;

procedure TDeleteNear.DeleteNearcontour(cntr: IIngeoContour);
var
  ci,vi: Integer;
  cntp: IIngeoContourPart;
  x,y,px,py,cv:Double;
begin
  for ci := 0 to cntr.Count - 1 do
  begin
    cntp:=cntr[ci];
    if cntp.VertexCount<3 then
      continue;
    cntp.GetVertex(0,px,py,cv);
    vi:=1;
    while vi<cntp.VertexCount do
    begin
      cntp.GetVertex(vi,x,y,cv);
      if LineLength(px,py,x,y)<0.1 then
      begin
        cntp.DeleteVertex(vi);
        continue;
      end;
      px:=x;
      py:=y;
      inc(vi);
    end;
  end;
end;

function TDeleteNear.LineLength(x1, y1, x2, y2: double): double;
begin
  Result:=Sqrt(Sqr(x1-x2)+sqr(y1-y2));
end;

end.
