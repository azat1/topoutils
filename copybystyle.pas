unit copybystyle;

interface
uses Classes, Ingeo_TLB,InScripting_TLB, Dialogs, Controls;
type
   TByStyleCopier=class
     public
       app:IIngeoApplication;
       srcstl:IIngeoStyle;
       dststlid,dstlayerid:string;
       mobjs:IIngeoMapObjects;
       constructor Create(app:IIngeoApplication);
       procedure LoadSrcStyle(objid:string;index:integer);
       function SelectDestStyle():boolean;
       function GetLayerFromStyle(stl:string):string;
       procedure MakeCopy;
       function CompareStyle(stl1,stl2:IIngeoStyle):boolean;
       function ComparePen(pen1,pen2:IInPen):boolean;
       function Colorcompare(color1,color2:Integer):boolean;
       procedure GetScreenRect(var x1,y1,x2,y2:double);
       procedure CopyShape(shape:IIngeoShape);
   end;

   procedure StartCopyByStyle(app:IIngeoApplication);
implementation

uses selstyle;

   procedure StartCopyByStyle(app:IIngeoApplication);
   var cpr:TByStyleCopier;
   begin
     if app.Selection.Count=0 then
     begin
       ShowMessage('ֽו גûהוכום מבתוךע!');
       exit;
     end;
     if app.Selection.Count>1 then
     begin
       ShowMessage('ֲûהוכום במכüרו קול 1 מבתוךע!');
       exit;
     end;
     cpr:=TByStyleCopier.Create(app);
     if cpr.SelectDestStyle() then
     begin
       cpr.MakeCopy;
     end;
     cpr.Free;
   end;
{ TByStyleCopier }

function TByStyleCopier.Colorcompare(color1, color2: Integer): boolean;
var z:integer;
begin
  Result:=false;
  z:=abs((color1 and $000000FF) - (color2 and $000000FF));
  if z>10 then
    exit;
  color1:=color1 shl 8;
  color2:=color2 shl 8;
  z:=abs((color1 and $000000FF) - (color2 and $000000FF shl 8));
  if z>10 then
    exit;
  color1:=color1 shl 8;
  color2:=color2 shl 8;
  z:=abs((color1 and $000000FF) - (color2 and $000000FF shl 8));
  if z>10 then
    exit;
  Result:=true;
end;

function TByStyleCopier.ComparePen(pen1, pen2: IInPen): boolean;
begin
  Result:=false;
  if Abs(pen1.WidthInMM-pen2.WidthInMM)>0.001 then exit;
  if pen1.Style<>pen2.Style then exit;
  if not ColorCompare(pen1.Color,pen2.Color) then
     exit;


  Result:=true;
end;

function TByStyleCopier.CompareStyle(stl1, stl2: IIngeoStyle): boolean;
var
  pntr1: IIngeoPainter;
  pntr2: IIngeoPainter;
  stdp1: IIngeoStdPainter;
  stdp2: IIngeoStdPainter;
begin
  REsult:=false;
  if (stl1.Painters.Count=0) or (stl2.Painters.Count=0)  then exit;
  pntr1:= stl1.Painters.Item[0];
  pntr2:= stl2.Painters.Item[0];
  if pntr1.PainterType<>pntr2.PainterType then
    exit;
  if pntr1.PainterType=inptStd then
  begin
    stdp1:=pntr1 as IIngeoStdPainter;
    stdp2:=pntr2 as IIngeoStdPainter;
    if not ComparePen(stdp1.Pen,stdp2.Pen)  then
      exit;
//    if not CompareColors(stdp1.Pen then

  end else exit;
  REsult:=true;

end;

procedure TByStyleCopier.CopyShape(shape: IIngeoShape);
var
  mobj: IIngeoMapObject;
  shp: IIngeoShape;
begin
  mobj:=mobjs.AddObject(dstlayerid);
  shp:=mobj.Shapes.Insert(-1,dststlid);
  shp.Contour.AddPartsFrom(shape.Contour);

  
end;

constructor TByStyleCopier.Create(app: IIngeoApplication);
var
  objid: string;
  index: Integer;
begin
  self.app:=app;
  objid:=app.Selection.IDs[0];
  index:=app.Selection.ShapeIndexes[0];
  LoadSrcStyle(objid,index);
end;

function TByStyleCopier.GetLayerFromStyle(stl: string): string;
begin
  Result:=app.ActiveDb.StyleFromID(stl).Layer.ID;
end;

procedure TByStyleCopier.GetScreenRect(var x1, y1, x2, y2: double);
begin
  app.MainWindow.MapWindow.Surface.PointDeviceToWorld(0,0,x1,y1);
  app.MainWindow.MapWindow.Surface.PointDeviceToWorld(app.MainWindow.MapWindow.Surface.DeviceRight,
    app.MainWindow.MapWindow.Surface.DeviceBottom,x2,y2);
end;

procedure TByStyleCopier.LoadSrcStyle(objid: string;index:integer);
var
  mobj: IIngeoMapObject;
begin
  mobj:=app.ActiveDb.MapObjects.GetObject(objid);
  if index=-1 then
  begin
    srcstl:= mobj.Shapes[0].Style;
  end else
  begin
    srcstl:=mobj.Shapes[index].Style;
  end;

end;

procedure TByStyleCopier.MakeCopy;
var
  mi: Integer;
  vm: IIngeoVectorMap;
  li: Integer;
  lr: IIngeoLayer;
  si: Integer;
  sstl,stl: IIngeoStyle;
  stylelist,larlist:TStringList;
  i: Integer;
  mq: IIngeoMapObjectsQuery;
  x1,y1,x2,y2:double;
  mobj: IIngeoMapObject;
  j: Integer;
  lv: IIngeoLayerViews;
begin
  stylelist:=TStringList.Create;
  larlist:=TStringList.Create;
//  larlist.Duplicates:=dupIgnore;
  //make styles list
  sstl:=srcstl;//app.ActiveDb.StyleFromID(srcstl);
  for mi := 0 to app.ActiveProjectView.MapViews.Count - 1 do
  begin
    if not app.ActiveProjectView.MapViews[mi].Visible then
      continue;
    if app.ActiveProjectView.MapViews[mi].Map.MapType=inmtRaster then
      continue;
    vm:=app.ActiveProjectView.MapViews[mi].Map as IIngeoVectorMap;
    lv:= app.ActiveProjectView.MapViews[mi].LayerViews;
    for li := 0 to lv.Count - 1 do
    begin
      if not lv[li].Visible then
        continue;
      lr:=lv[li].Layer;

      if lr.ID=dstlayerid then
        continue;
      for si := 0 to lr.Styles.Count - 1 do
      begin
        stl:=lr.Styles[si];
        if CompareStyle(stl,sstl) then
        begin
          stylelist.Add(stl.ID);
          larlist.Add(lr.ID);
        end;
      end;
    end;
  end;
  //select objects
  mobjs:=app.ActiveDb.MapObjects;
  GetScreenRect(x1,y1,x2,y2);
  for i := 0 to larlist.Count - 1 do
  begin
    mq:=app.ActiveDb.MapObjects.QueryByRect(larlist[i],x1,y1,x2,y2,false);
    while not mq.EOF do
    begin
      mobj:=app.ActiveDb.MapObjects.GetObject(mq.ObjectID);
      for j := 0 to mobj.Shapes.Count - 1 do
      begin
        if stylelist.IndexOf( mobj.Shapes[j].StyleID)<>-1  then
        begin
          CopyShape(mobj.Shapes[j]);
        end;

      end;
      mobjs.UpdateChanges;
      mq.MoveNext;
    end;
  end;
end;

function TByStyleCopier.SelectDestStyle: boolean;
var f:TfSelectStyle;
begin
  f:=TfSelectStyle.Create(nil);
  if f.ShowModal=mrok then
  begin
    dststlid:=f.selstyle;
    dstlayerid:=GetLayerFromStyle(dststlid);
    REsult:=true;

   // objstyle:=selstyle;
  end else
  REsult:=false;
  f.Free;
end;

end.
