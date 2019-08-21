unit makecircle;

interface
uses sysutils,Ingeo_TLB, InScripting_TLB,controls, dialogs, forms, m2addon;

procedure StartMakeCircle(app:IIngeoApplication);
implementation

uses SELSTYLE;

procedure MakeOneCircleForPoint(x,y:double;app:IIngeoApplication;stl:string;mobjs:IIngeoMapObjects;r:double);
var
  lar: string;
  mobj: IIngeoMapObject;
  shp: IIngeoShape;
  cntp: IIngeoContourPart;
begin
  lar:=app.ActiveDb.StyleFromID(stl).Layer.ID;
  mobj:=mobjs.AddObject(lar);
  shp:=mobj.Shapes.Insert(-1,stl);
  cntp:=shp.Contour.Insert(-1);
  cntp.InsertVertex(-1,x,y-r,1);
  cntp.InsertVertex(-1,x,y+r,1);
  cntp.Closed:=true;
//  cntp.InsertVertex(-1,x,y+r,1);



end;

procedure MakeOneCircle( app:IIngeoApplication;id:string;r:double;stl:string);
var
  mobj: IIngeoMapObject;
  mobjs:IIngeoMapObjects;
  si: Integer;
  ci: Integer;
  cntr: IIngeoContourPart;
  vi: Integer;
  x,y,cv:double;
begin
  mobjs:=app.ActiveDb.MapObjects;
  mobj:=app.ActiveDb.MapObjects.GetObject(id);
  for si := 0 to mobj.Shapes.Count - 1 do
  begin
    for ci := 0 to mobj.Shapes[si].Contour.Count - 1 do
    begin
      cntr:=mobj.Shapes[si].Contour[ci];
      for vi := 0 to cntr.VertexCount - 1 do
      begin
        cntr.GetVertex(vi,x,y,cv);
        MakeOneCircleForPoint(x,y,app,stl,mobjs,r);
      end;
    end;
  end;
  mobjs.UpdateChanges;
end;



procedure StartMakeCircle(app:IIngeoApplication);
var sr:string;
    r:double;
  f: TfSelectStyle;
  stl: string;
  llar: IIngeoLayer;
  i: Integer;
begin
  if app.Selection.Count=0 then
  begin
    ShowMessage('Не выделены объекты!');
    exit;
  end;
  if not InputQuery('Сделать кружочки','Введите радиус',sr) then
  begin
    exit;
  end;
  if not TryStrToFloat(sr,r)   then
  begin
    ShowMessage('Неверное число!');
    exit;
  end;
  f:=TfSelectStyle.Create(nil);
  if f.ShowModal=mrOk then
  begin
    stl:=PM2ID(f.trv1.Selected.Data)^;
  //  llar:=app.ActiveDb.StyleFromID(stl).Layer;
   // leLarName.Text:=llar.Map.Name+'\'+llar.Name;
  //  sellar:=llar.ID;
  end else
  begin
    f.Free;
    exit;
  end;
  f.Free;
  for i := 0 to app.Selection.Count - 1 do
  begin
    MakeOneCircle(app,app.Selection.ids[i],r,stl);
  end;
end;




end.
