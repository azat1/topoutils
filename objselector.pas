unit objselector;

interface
uses Classes,SysUtils,Ingeo_TLB;
type
   TObjectSelector=class
     private
       app:IIngeoApplication;
     public
       constructor Create(app: IIngeoApplication);
       procedure SelectObjectsByLength(l1,l2:double);
   end;
implementation

{ TObjectSelector }

constructor TObjectSelector.Create(app: IIngeoApplication);
begin
  self.app:=app;
end;

procedure TObjectSelector.SelectObjectsByLength(l1, l2: double);
var
  i: Integer;
  mobj: IIngeoMapObject;
  objs:TStringList;
begin
  objs:=TStringList.Create;
  for i := 0 to app.Selection.Count - 1 do
  begin
    mobj:=app.ActiveDb.MapObjects.GetObject(app.Selection.IDs[i]);
    if (mobj.Perimeter>=l1) and (mobj.Perimeter<=l2)   then
    begin
      objs.Add(mobj.ID);
    end;

  end;
  app.Selection.DeselectAll;
  for i := 0 to objs.Count - 1 do
     app.Selection.Select(objs[i],-1);
end;

end.
