unit ufastselect;

interface
uses Ingeo_TLB;
function FastSelect(app:IIngeoApplication):integer;

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

end.
