unit lineconnect;

interface
uses Ingeo_TLB, M2Addon, M2AddonD, addn, types, InScripting_TLB, graphics, windows;
type
    TLCPointSelector=class (TM2CustomEditor)
    private
      faddn:TFAd;
    public
      idobj1,idobj2:string;
      styleid:string;
      line1,line2:IIngeoContourPart;
      px,py:array of double;

      pointselecting:boolean;
      npx,npy:double;
      nearpoint:boolean;
//      callform:TForm;
//      eX,eY:TEdit;
      cx,cy,er:double;
      pcount:integer;
      rtype:integer;
      angle:double;
      constructor Create(anAddon:TFad);
      destructor Destroy; override;
      function GetEditorOptions: TM2EditorOptions; override;

      procedure HideDragging; override;
      procedure ShowDragging(aMouse: TPoint); override;

      procedure MouseDown(aButton: TM2MouseButton; aShift: TM2ShiftState; aMouse: TPoint); override;
      procedure MouseMove(aShift: TM2ShiftState; aMouse: TPoint); override;
  		procedure KeyDown(AKey: Word; AShift: TM2ShiftState); override;

      function GetContextMacroList(aMouse: TPoint): IM2ContextMacroAttrsList; override;
      procedure ExecuteMacro(aCmd: Longint; const aParams: TM2String); override;
      procedure DrawPoints;
      function FindPoint(p:TM2Point):TM2Point;
      function LineLength(p1,p2:TM2Point):real;
  		procedure Notification(AWhat: TM2EditorNotification); override;
      procedure DrawNearPoint;
      procedure FindNearPoint(mx,my:integer);
      function GetObjectNearPoint(oid:string;x,y:double;var fx,fy:double;maxd:double):boolean;
      procedure DrawPolygon;
      procedure LoadContourParts;
      procedure CreateObject;

    end;
var geditor:TLCPointSelector;
procedure MakeLineConnect;
implementation
uses dialogs;
procedure MakeLineConnect;
begin
  if gAddon2.Selection.Count<>2 then
  begin
    ShowMessage('Должно быть выделено два объекта!');
    exit;
  end;
  if geditor<>nil then
    exit;
  geditor:=TLCPointSelector.Create(gAddon);
  gAddon.MapView.AddEditor(geditor.IEditor);
end;
{ TUPointSelector }

constructor TLCPointSelector.Create(anAddon: TFad);
begin
  inherited Create;
  idobj1:=gAddon2.Selection.IDs[0];
  idobj2:=gAddon2.Selection.IDs[1];
  LoadContourParts;
  faddn:=anAddon;
  pointselecting:=False;
//  showsolves:=False;
//  callform:=cform;
  angle:=0;
  pcount:=1;

end;

procedure TLCPointSelector.CreateObject;
var lar:string;
    mobjs:IIngeoMapObjects;
    obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
  i: Integer;
begin
  lar:=gAddon2.ActiveDb.StyleFromID(styleid).Layer.ID;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  obj:=mobjs.AddObject(lar);
  shp:=obj.Shapes.Insert(-1,styleid);
  cntp:=shp.Contour.Insert(-1);
  for i := 0 to Length(px)-1 do
  begin
    cntp.InsertVertex(-1,px[i],py[i],0);
  end;
  mobjs.UpdateChanges;
  gAddon2.MainWindow.MapWindow.Invalidate;
end;

destructor TLCPointSelector.Destroy;
begin

  inherited;
end;

procedure TLCPointSelector.DrawNearPoint;
var cntr:IIngeoContour;
    cntp:IIngeoContourPart;
    wx,wy,wd:double;
    surf:IIngeoPaintSurface;
    I:INTEGER;
begin
  if not nearpoint then
  begin
    cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
    wx:=npx;wy:=npy;
    surf:=gAddon2.MainWindow.MapWindow.Surface;
    wd:=Surf.SizeDeviceToWorld(3);
    cntp:=cntr.Insert(-1);
    for I := 0 to Length(px) - 1 do
    begin
      cntp.InsertVertex(-1,px[i],py[i],0);
    end;
    Surf.Pen.Style:=inpsSolid;
    Surf.Pen.Color:=clBlue;
    Surf.Pen.Mode:=inpmXor;
    Surf.Pen.WidthInMM:=1;
    Surf.Pen.ForZoomScale:=0;
    surf.PaintContour(cntr,true);
    exit;
  end;

//  gAddon2.MainWindow.MapWindow.Surface.
end;

procedure TLCPointSelector.DrawPoints;
begin

end;

procedure TLCPointSelector.DrawPolygon;
begin

end;

procedure TLCPointSelector.ExecuteMacro(aCmd: Integer; const aParams: TM2String);
begin
  inherited;

end;

procedure TLCPointSelector.FindNearPoint(mx, my: integer);
var mq:IIngeoMapObjectsQuery;
    i,i1,i2:integer;
    vmap:IIngeoVectorMap;
    mv:IIngeoMapView;
    lars:array of string;
  mi,li: Integer;
  larcount: integer;
  fx,fy,wd,wx,wy,x1,y1,x2,y2,cv:double;
  foid,larid:widestring;
  spi:integer;
  l,tl,ml: double;
  tc:IIngeoContour;
  tl1,tl2,tl3,tl4,tll:IIngeoContourPart;
begin
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(mx,my,wx,wy);
//  wd:=gAddon2.MainWindow.MapWindow.Surface.SizeDeviceToWorld(10);
//  mq:=gAddon2.ActiveDb.MapObjects.QueryByRect(lars,wx-wd,wy-wd,wx+wd,wy+wd,false);
  i1:=-1;
  l:=1e30;
  for i := 0 to line1.VertexCount - 1 do
  begin
    line1.GetVertex(i,fx,fy,cv);
    tl:=Sqrt(SQr(wx-fx)+SQR(wy-fy));
    if tl<l then
    begin
      i1:=i;
      l:=tl;
    end;
  end;
  i2:=-1;
  l:=1e30;
  for i := 0 to line2.VertexCount - 1 do
  begin
    line2.GetVertex(i,fx,fy,cv);
    tl:=Sqrt(SQr(wx-fx)+SQR(wy-fy));
    if tl<l then
    begin
      i2:=i;
      l:=tl;
    end;
  end;

  tc:=gAddon2.createObject(inocContour,0) as IIngeoContour;
  tl1:=tc.Insert(-1); //first variant
  for i := 0 to i1 do
  begin
    line1.GetVertex(i,fx,fy,cv);
    tl1.InsertVertex(-1,fx,fy,0);
  end;
  for i := i2 downto 0 do
  begin
    line2.GetVertex(i,fx,fy,cv);
    tl1.InsertVertex(-1,fx,fy,0);
  end;

  tl2:=tc.Insert(-1); //second variant
  for i := 0 to i1 do
  begin
    line1.GetVertex(i,fx,fy,cv);
    tl2.InsertVertex(-1,fx,fy,0);
  end;
  for i := i2 to line2.VertexCount-1 do
  begin
    line2.GetVertex(i,fx,fy,cv);
    tl2.InsertVertex(-1,fx,fy,0);
  end;

  tl3:=tc.Insert(-1); //third variant
  for i := line1.VertexCount-1 downto i1 do
  begin
    line1.GetVertex(i,fx,fy,cv);
    tl3.InsertVertex(-1,fx,fy,0);
  end;
  for i := i2 downto 0 do
  begin
    line2.GetVertex(i,fx,fy,cv);
    tl3.InsertVertex(-1,fx,fy,0);
  end;

  tl4:=tc.Insert(-1); //fourth variant
  for i := line1.VertexCount-1 downto i1 do
  begin
    line1.GetVertex(i,fx,fy,cv);
    tl4.InsertVertex(-1,fx,fy,0);
  end;
  for i := i2 to line2.VertexCount-1 do
  begin
    line2.GetVertex(i,fx,fy,cv);
    tl4.InsertVertex(-1,fx,fy,0);
  end;
{  if tl1.Perimeter>tl2.Perimeter then
  begin
    if tl1.Perimeter>tl3.Perimeter then
    begin
      tll:=tl1;
    end else
    begin
      if tl2.Perimeter>tl3.Perimeter then
         tll:=tl2
           else  tll:=tl3;
    end;
  end else
  begin
    if tl3.Perimeter>tl2.Perimeter then
    begin
      tll:=tl3;
    end else tll:=tl2;
  end;}
  tll:=tl1;
  if tl2.Perimeter>tll.Perimeter then tll:=tl2;
  if tl3.Perimeter>tll.Perimeter  then tll:=tl3;
  if tl4.Perimeter>tll.Perimeter  then tll:=tl4;

  SetLength(px,tll.VertexCount);
  SetLength(py,tll.VertexCount);
  for i := 0 to tll.VertexCount - 1 do
  begin
    tll.GetVertex(i,fx,fy,cv);
    px[i]:=fx;
    py[i]:=fy;
  end;
end;

function TLCPointSelector.FindPoint(p: TM2Point): TM2Point;
begin

end;

function TLCPointSelector.GetContextMacroList(
  aMouse: TPoint): IM2ContextMacroAttrsList;
begin

end;

function TLCPointSelector.GetEditorOptions: TM2EditorOptions;
begin
	Result := eopProcessPhase or eopMouseMove or eopMouseDown or eopDragging or eopNotification or
             eopKeyDown;
end;

function TLCPointSelector.GetObjectNearPoint(oid: string; x, y: double; var fx,
  fy: double; maxd: double): boolean;
var obj:IIngeoMapObject;
  si: Integer;
  sp:IIngeoShape;
  ci: Integer;
  cntp:IIngeoContourPart;
  vi: Integer;
  wx,wy,cv,ml,l:double;
begin
  obj:=gAddon2.ActiveDb.MapObjects.GetObject(oid);
  ml:=maxd;
  REsult:=False;
  for si := 0 to obj.Shapes.Count - 1 do
  begin
    sp:=obj.Shapes.Item[si];
    if not sp.DefineGeometry then continue;
    for ci := 0 to sp.Contour.Count - 1 do
    begin
      cntp:=sp.Contour.Item[ci];
      for vi := 0 to cntp.VertexCount - 1 do
      begin
        cntp.GetVertex(vi,wx,wy,cv);
        if (abs(wx-x)>maxd) or (abs(wy-y)>maxd)  then continue;
        l:=SQRT(SQR(x-wx)+SQR(y-wy));
        if l<ml then
        begin
          ml:=l;
          Result:=True;
          fx:=wx;fy:=wy;
        end;
      end;
    end;
  end;
end;

procedure TLCPointSelector.HideDragging;
begin
  inherited;
//  if pointselecting then
    DrawNearPoint;

end;

procedure TLCPointSelector.KeyDown(AKey: Word; AShift: TM2ShiftState);
begin
  inherited;
  if AKey=VK_ESCAPE then
  begin
    gAddon.MapView.RemoveEditor(IEditor);
    geditor:=nil;
    Free;
    gAddon2.MainWindow.MapWindow.StopHandler;
    gAddon2.MainWindow.MapWindow.Invalidate;
  end;

end;

function TLCPointSelector.LineLength(p1, p2: TM2Point): real;
begin

end;

procedure TLCPointSelector.LoadContourParts;
var mobjs:IIngeoMapObjects;
    obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    x,y,cv:double;
  i: Integer;
  j: Integer;
begin
  mobjs:=gAddon2.ActiveDb.MapObjects;
  obj:=mobjs.GetObject(idobj1);
  for i := 0 to obj.Shapes.Count - 1 do
  begin
    shp:=obj.Shapes.Item[i];
    if shp.DefineGeometry then
    begin
      cntp:=shp.Contour.Item[0];
      line1:=cntp;
      styleid:=shp.StyleID;
      break;
    end;
  end;
  obj:=mobjs.GetObject(idobj2);
  for i := 0 to obj.Shapes.Count - 1 do
  begin
    shp:=obj.Shapes.Item[i];
    if shp.DefineGeometry then
    begin
      cntp:=shp.Contour.Item[0];
      line2:=cntp;
      break;
    end;
  end;
end;

procedure TLCPointSelector.MouseDown(aButton: TM2MouseButton;
  aShift: TM2ShiftState; aMouse: TPoint);
//var cf:TfLinZasechka;
begin
  inherited;
  if (aButton=inmbLeft)   then
  begin
    CreateObject;
    gAddon.MapView.RemoveEditor(IEditor);
    geditor:=nil;
    Free;
    gAddon2.MainWindow.MapWindow.StopHandler;
//    eX.Text:=Format('%.4f',[npx]);
//    eY.Text:=Format('%.4f',[npy]);

//    callform.Show;
//    cf:=TfLinZasechka(callform);
//    cf.sgData.Cells[1,cf.sgData.Row]:=Format('%.4f',[npx]);
//    cf.sgData.Cells[2,cf.sgData.Row]:=Format('%.4f',[npy]);
//    cf.Show;
//    pointselecting:=False;
  end;
end;


procedure TLCPointSelector.MouseMove(aShift: TM2ShiftState; aMouse: TPoint);
begin
  inherited;
  HideDragging;
//  if pointselecting then
    FindNearPoint(amouse.X,amouse.Y);
  ShowDragging(aMouse);

end;

procedure TLCPointSelector.Notification(AWhat: TM2EditorNotification);
begin
  inherited;

end;

procedure TLCPointSelector.ShowDragging(aMouse: TPoint);
begin
  inherited;
//  if pointselecting then
    DrawNearPoint;
end;
initialization
  geditor:=nil;
end.
