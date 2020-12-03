unit ufastselect;

interface
uses Ingeo_TLB;
function FastSelect(app:IIngeoApplication):integer;
function FastSelect2(app:IIngeoApplication):integer;

implementation
uses Classes,SysUtils;

function FastSelect(app:IIngeoApplication):integer;
var
  i: Integer;
  stllist:TStringList;
  mobjs: IIngeoMapObjects;
  mobj: IIngeoMapObject;
  si: Integer;
  vr:array of string;
  mq: IIngeoMapObjectsQuery;
begin
  if app.Selection.Count=0 then
    exit;
  stllist:=TStringList.Create;
  stllist.Sorted:=true;
  stllist.Duplicates:=dupIgnore;
  mobjs:=app.ActiveDb.MapObjects;
  for i := 0 to app.Selection.Count - 1 do
  begin
    mobj:=mobjs.GetObject(app.Selection.IDs[i]);
    for si := 0 to mobj.Shapes.Count - 1 do
    begin
      stllist.Add(mobj.Shapes[si].StyleID);
    end;
  end;
  SetLength(vr,stllist.Count);
  for i := 0 to stllist.Count - 1 do
  begin
    vr[i]:=stllist[i];
  end;
  mq:= mobjs.QueryByStyle(vr,inqsOneOrMore);
  while not mq.EOF do
  begin
    app.Selection.Select(mq.ObjectID,-1);
    mq.MoveNext;
  end;
end;

function FastSelect2(app:IIngeoApplication):integer;
var
  i: Integer;
  stllist,objlist:TStringList;
  mobjs: IIngeoMapObjects;
  mobj: IIngeoMapObject;
  si: Integer;
  vr:array of string;
  mq: IIngeoMapObjectsQuery;
  x1,y1,x2,y2:double;
begin
  if app.Selection.Count=0 then
    exit;
  stllist:=TStringList.Create;
  stllist.Sorted:=true;
  stllist.Duplicates:=dupIgnore;
  mobjs:=app.ActiveDb.MapObjects;
  for i := 0 to app.Selection.Count - 1 do
  begin
    mobj:=mobjs.GetObject(app.Selection.IDs[i]);
    for si := 0 to mobj.Shapes.Count - 1 do
    begin
      stllist.Add(mobj.Shapes[si].StyleID);
    end;
  end;
  SetLength(vr,stllist.Count);
  for i := 0 to stllist.Count - 1 do
  begin
    vr[i]:=stllist[i];
  end;

  app.MainWindow.MapWindow.Surface.PointDeviceToWorld(0,0,x1,y1);
  app.MainWindow.MapWindow.Surface.PointDeviceToWorld(
     app.MainWindow.MapWindow.Surface.DeviceRight,
     app.MainWindow.MapWindow.Surface.DeviceBottom,x2,y2);
  objlist:=TStringList.Create;
  mq:=mobjs.QueryByRect(app.ActiveProjectView.ActiveLayerView.Layer.ID,x1,y1,x2,y2,false);
  while not mq.EOF do
  begin
    objlist.Add(mq.ObjectID);
    mq.MoveNext;
  end;
  mq:= mobjs.QueryByStyle(vr,inqsOneOrMore);
  while not mq.EOF do
  begin
    //mobj:=mobjs.GetObject(mq.ObjectID);
    if objlist.IndexOf(mq.ObjectID)<>-1 then
         app.Selection.Select(mq.ObjectID,-1);
    mq.MoveNext;
  end;
  objlist.Free;
  stllist.Free;
end;

end.
