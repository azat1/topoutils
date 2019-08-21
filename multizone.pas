unit multizone;

interface
uses Classes,SysUtils, Ingeo_TLB,InScripting_TLB;
type
   TMultiZoneCreator=class
     public
       app:IIngeoApplication;
       stlid:string;
       width:double;
       constructor Create(app:IIngeoApplication;stlid:string;width:double);
       procedure CreateZone;
   end;
implementation

{ TMultiZoneCreator }

constructor TMultiZoneCreator.Create(app: IIngeoApplication; stlid: string; width: double);
begin
  self.app:=app;
  self.stlid:=stlid;
  self.width:=width;
end;

procedure TMultiZoneCreator.CreateZone;
var
  maincntr: IIngeoContour;
  i: Integer;
  mobjs:IIngeoMapObjects;
  mobj: IIngeoMapObject;
  si: Integer;
  bcntr: IIngeoContour;
  newobj: IIngeoMapObject;
  lar: string;
  shp: IIngeoShape;
begin
  if app.Selection.Count=0 then
    exit;
  mobjs:=app.ActiveDb.MapObjects;
  maincntr:=app.CreateObject(inocContour,0) as IIngeoContour;
  for i := 0 to app.Selection.Count - 1 do
  begin
    mobj:=mobjs.GetObject(app.Selection.IDs[i]);
    for si := 0 to mobj.Shapes.Count - 1 do
    begin
      if mobj.Shapes[si].DefineGeometry then
      begin
        bcntr:=mobj.Shapes[si].Contour.BuildBufferZone(width);
        maincntr.Combine(inccOr,bcntr);
      end;
    end;

  end;
  lar:=app.ActiveDb.StyleFromID(stlid).Layer.ID;
  newobj:=mobjs.AddObject(lar);
  shp:=newobj.Shapes.Insert(-1,stlid);
  shp.Contour.AddPartsFrom(maincntr);
  mobjs.UpdateChanges;


end;

end.
