unit tolinears;

interface
uses addn,Ingeo_TLB,InScripting_TLB, Dialogs;

procedure StartToLinear();

implementation

procedure StartToLinear();
var
  i: Integer;
  mobjs: IIngeoMapObjects;
  mobj: IIngeoMapObject;
  si: Integer;
  ci: Integer;
  cntp: IIngeoContourPart;
  x: double;
  y: double;
  cv: double;
begin
  if gAddon2.Selection.Count=0 then
  begin
    ShowMessage('Нет выделенных объектов!');

  end;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  for i := 0 to gaddon2.Selection.Count - 1 do
  begin
    mobj:=mobjs.GetObject(gAddon2.Selection.IDs[i]);
    for si := 0 to mobj.Shapes.Count - 1 do
    begin
      for ci := 0 to mobj.Shapes[si].Contour.Count - 1 do
      begin
        cntp:=mobj.Shapes[si].Contour[ci];
        if cntp.Closed then
        begin
          cntp.GetVertex(0,x,y,cv);
          cntp.Closed:=false;
          cntp.InsertVertex(-1,x,y,0);
        end;
      end;
    end;
  end;
  mobjs.updatechanges;
end;

end.
