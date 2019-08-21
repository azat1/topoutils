unit cntrcloser;

interface
uses Controls,Forms,Dialogs,Ingeo_TLB;
   procedure CloseAll(app:IngeoApplication);
   procedure UnCloseAll(app:IngeoApplication);

implementation

  procedure CloseAll(app:IngeoApplication);
  var
  i: Integer;
  mobjs: IIngeoMapObjects;
  mobj: IIngeoMapObject;
  si: Integer;
  ci: Integer;
  shp: IIngeoShape;
   begin
     if app.Selection.Count=0 then
     begin
       ShowMessage('Не выделены объекты!');
       exit;
     end;

     if MessageDlg('Замкнуть контуры всех выделенных объектов!',mtWarning,
     [mbYes,mbNo],0)<>mrYes then exit;
     mobjs:=app.ActiveDb.MapObjects;
     for i := 0 to app.Selection.Count - 1 do
     begin
       mobj:=mobjs.GetObject(app.Selection.IDs[i]);
       for si := 0 to mobj.Shapes.Count - 1 do
       begin
         if not mobj.Shapes[si].DefineGeometry then
           continue;
         shp:=mobj.Shapes[si];
         for ci := 0 to shp.Contour.Count - 1 do
         begin
           if not shp.Contour[ci].Closed then
             shp.Contour[ci].Closed:=true;
         end;

       end;
       if (i mod 1000)=0 then
           mobjs.UpdateChanges;
     end;
     mobjs.UpdateChanges;


   end;

  procedure UnCloseAll(app:IngeoApplication);
  var
  i: Integer;
  mobjs: IIngeoMapObjects;
  mobj: IIngeoMapObject;
  si: Integer;
  ci: Integer;
  shp: IIngeoShape;
   begin
     if app.Selection.Count=0 then
     begin
       ShowMessage('Не выделены объекты!');
       exit;
     end;

     if MessageDlg('Разомкнуть контуры всех выделенных объектов!',mtWarning,
     [mbYes,mbNo],0)<>mrYes then exit;
     mobjs:=app.ActiveDb.MapObjects;
     for i := 0 to app.Selection.Count - 1 do
     begin
       mobj:=mobjs.GetObject(app.Selection.IDs[i]);
       for si := 0 to mobj.Shapes.Count - 1 do
       begin
         if not mobj.Shapes[si].DefineGeometry then
           continue;
         shp:=mobj.Shapes[si];
         for ci := 0 to shp.Contour.Count - 1 do
         begin
           if shp.Contour[ci].Closed then
             shp.Contour[ci].Closed:=false;
         end;

       end;
       if (i mod 1000)=0 then
           mobjs.UpdateChanges;
     end;
     mobjs.UpdateChanges;


   end;

end.
