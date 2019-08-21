unit pinsedit;

interface
uses Windows, M2Addon, M2AddonD, addn, math,Ingeo_TLB, InScripting_TLB;

type
    TPinsSelector=class (TM2CustomEditor)
    private
      faddn:TFAd;
    public
      line:array [0..100000] of tm2point;
      linecount:integer;
      p1,p2:tm2point;
      objstyle,linelar,pinlar:string;
      active:boolean;
      mobjs:IIngeoMapObjects;
      selectedobj:IIngeoMapObject;
      selectedcnt:IIngeoContourPart;
      selectedpnt:integer;

 //     procedure Calculate;
      constructor Create(anAddon:TFad);
      destructor Destroy; override;
      function GetEditorOptions: TM2EditorOptions; override;

      procedure HideDragging; override;
      procedure ShowDragging(aMouse: TPoint); override;

      procedure MouseMove(aShift: TM2ShiftState; aMouse: TPoint); override;
      procedure MouseDown(aButton: TM2MouseButton; aShift: TM2ShiftState; aMouse: TPoint); override;

      function GetContextMacroList(aMouse: TPoint): IM2ContextMacroAttrsList; override;
      procedure ExecuteMacro(aCmd: Longint; const aParams: TM2String); override;
      procedure DrawPoints;
      function FindPoint(p:TM2Point):TM2Point;
      function LineLength(p1,p2:TM2Point):real;
      procedure Calculate;
      function CalcAngle(p1,p2:TM2Point): real;
      function CalcPoint(p:TM2Point;an,d:real):TM2Point;
  		procedure Notification(AWhat: TM2EditorNotification); override;
      procedure LoadOS(obj:string);
      procedure CreateObject;
      function CalcPoint2(x1,y1,x2,y2:double;p:TM2Point;d:double;var res:TM2Point):boolean;
    end;

//Var PointSelector:TPointSelector;

implementation

uses Controls, SysUtils, Graphics, Linear, navigator, pincreate;

const
   cmEnterP1=1;
   cmEnterP2=2;
   cmMakeP3=3;
   psize=2;
	kPen: TM2Pen = (
		Style: kpsSolid;
		WidthInMM: 0;
		ForZoomScale: 1/10000;
		Color: clGreen;
	);

	kPen2: TM2Pen = (
		Style: kpsSolid;
		WidthInMM: 0;
		ForZoomScale: 1/10000;
		Color: clRed;
	);

   kContextMacros: array [0..3] of TM2ContextMacroAttrs = (
		( Command: 0;
			Name: '';
			Hint: '';
			Path: '-';
			ShortCut: 0;
			State: 0;	),
		( Command: cmEnterP1;
			Name: 'EnterP1';
			Hint: '';
			Path: 'Ввести первую точку';
			ShortCut: 0;
			State: 0; ),
		( Command: cmEnterP2;
			Name: 'EnterP2';
			Hint: '';
			Path: 'Ввести вторую точку';
			ShortCut: 0;
			State: 0; ),
		( Command: cmMakeP3;
			Name: 'MakeP3';
			Hint: '';
			Path: 'Создать точку';
			ShortCut: 0;
			State: 0; )
	);

constructor TPinsSelector.Create;
begin
  inherited Create;
  faddn:=anAddon;
  linecount:=0;
  active:=True;
  linelar:='';
  pinlar:='';
  mobjs:=gAddon2.ActiveDb.MapObjects;
end;

procedure TPinsSelector.CreateObject;
var
    mobj:IIngeoMapObject;
    shp:IIngeoShape;
    lar:string;
    cntp:IIngeoContourPart;
    f:TfPinCreate;
    cc,ind:integer;
    dist,wx,wy,x1,y1,x2,y2,cv:double;
    style:string;
    ev,pv,lv:TM2Point;
  I,pcc: Integer;
  ilar:IIngeoLayer;
begin
  if selectedobj=nil then
  begin
    MessageBox(0,'Не выбрана линия!','Создание опор',MB_OK+MB_ICONSTOP);
    exit;
  end;
  selectedcnt.GetVertex(selectedpnt,x1,y1,cv);
  ind:=selectedpnt+1;
  if ind=selectedcnt.VertexCount then
    ind:=0;
  selectedcnt.GetVertex(ind,x2,y2,cv);
  f:=TfPinCreate.Create(nil);
  f.linelength:=SQRT(SQR(x1-x2)+SQR(y1-y2));
  f.pinlayer:=pinlar;
  if f.ShowModal=mrOk then
  begin
    ev.X:=(x2-x1)/f.linelength;
    ev.Y:=(y2-y1)/f.linelength;
    lv.X:=-ev.Y;
    lv.Y:=ev.X;
    if f.autodist then
    begin
      pv.X:=ev.X*f.linelength/(f.pcount+1);
      pv.Y:=ev.Y*f.linelength/(f.pcount+1);
      pcc:=f.pcount;
    end else
    begin
      pv.X:=ev.X*f.pdist;
      pv.Y:=ev.Y*f.pdist;
      pcc:=Round(Int(f.linelength/f.pdist)-1);
    end;
    ilar:=gAddon2.ActiveDb.LayerFromID(pinlar);
    style:=ilar.Styles.Item[f.cbStyle.itemindex].ID;
    wx:=x1;
    wy:=y1;
    for I := 1 to pcc do
    begin
      wx:=wx+pv.X;
      wy:=wy+pv.Y;
      mobj:=mobjs.AddObject(pinlar);
      shp:=mobj.Shapes.Insert(-1,style);
      cntp:=shp.Contour.Insert(-1);
      cntp.InsertVertex(-1,wx,wy,0);
      selectedcnt.InsertVertex(selectedpnt+1,wx,wy,0);
      if f.cbMakeVector.Checked then
        cntp.InsertVertex(-1,wx+lv.X,wy+lv.Y,0);
      inc(selectedpnt);
    end;

  end;
  f.Free;
//  lar:=gAddon2.ActiveDb.StyleFromID(objstyle).Layer.ID;
//  mobjs:=gAddon2.ActiveDb.MapObjects;

{  mobj:=mobjs.AddObject(lar);
  shp:=mobj.Shapes.Insert(-1,objstyle);
  cntp:=shp.Contour.Insert(-1);
  cntp.InsertVertex(-1,p1.X,p1.Y,0);
  cntp.InsertVertex(-1,p2.X,p2.Y,0);}
  mobjs.UpdateChanges;
end;

destructor TPinsSelector.Destroy;
begin
//  PointSelector:=nil;
  inherited Destroy;
end;

function TPinsSelector.GetEditorOptions: TM2EditorOptions;
begin
	Result := eopProcessPhase or eopMouseMove or eopMouseDown or
			eopContextMenu or eopDragging or eopNotification;
end;

procedure TPinsSelector.HideDragging;
begin
  DrawPoints;
end;

procedure TPinsSelector.ShowDragging(aMouse: TPoint);
begin
  DrawPoints;
end;

procedure TPinsSelector.MouseMove(aShift: TM2ShiftState; aMouse: TPoint);
begin
  HideDragging;
  p1:=gAddon.MapView.PointFromDevice(aMouse);
  Calculate;
  ShowDragging(aMouse);
//  gAddon.MapView.
end;

procedure TPinsSelector.MouseDown(aButton: TM2MouseButton; aShift: TM2ShiftState; aMouse: TPoint);
begin
//  if not active then
//      exit;
  if aButton=kmbLeft then
     CreateObject;
//  inherited MouseDown(aButton,aShift,AmOUSE);
end;

function TPinsSelector.GetContextMacroList(aMouse: TPoint): IM2ContextMacroAttrsList;
begin
	Result := inherited GetContextMacroList(aMouse);
end;

procedure TPinsSelector.ExecuteMacro(aCmd: Longint; const aParams: TM2String);
begin
end;

procedure TPinsSelector.DrawPoints;
var ap:array [0..10] of tm2point;
    ps:double;
    cntr:IIngeoContour;
    surf:IIngeoPaintSurface;
    cntp:IIngeoContourPart;
    x1,y1,x2,y2,cv:double;
    ind:integer;
begin
  if selectedobj=nil then
     exit;
  selectedcnt.GetVertex(selectedpnt,x1,y1,cv);
  ind:=selectedpnt+1;
  if ind=selectedcnt.VertexCount then
    ind:=0;
  selectedcnt.GetVertex(ind,x2,y2,cv);

  cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
  surf:=gAddon2.MainWindow.MapWindow.Surface;
  ps:=Surf.SizeDeviceToWorld(5);
  cntp:=cntr.Insert(-1);
  cntp.InsertVertex(-1,x1,y1,0);
  cntp.InsertVertex(-1,x2,y2,0);
  Surf.Pen.Style:=inpsSolid;
  Surf.Pen.Color:=clRed;
  Surf.Pen.Mode:=inpmXor;
  Surf.Pen.WidthInMM:=1;
  Surf.Pen.ForZoomScale:=gAddon.MapView.Scale;
  surf.PaintContour(cntr,true);
end;

function TPinsSelector.FindPoint(p:TM2Point):TM2Point;
begin
end;

function TPinsSelector.LineLength(p1,p2:TM2Point):real;
begin
  Result:=SQRT(SQR(p1.X-p2.X)+SQR(p1.Y-p2.Y));
end;

procedure TPinsSelector.LoadOS(obj: string);
var mobj:IIngeoMapObject;
  i: Integer;
  shp:IIngeoShape;
  cntp:IIngeoContourPart;
  x,y,c:Double;
begin
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(obj);
  shp:=nil;
  for i := 0 to mobj.Shapes.Count - 1 do
  begin
    if mobj.Shapes.Item[i].DefineGeometry then
    begin
       shp:=mobj.Shapes.Item[i];
       break;
    end;
  end;
  cntp:=shp.Contour.Item[0];
//  for I := 0 to shp.Contour.Item.Count - 1 do
  for i := 0 to cntp.VertexCount - 1 do
  begin
    cntp.GetVertex(i,x,y,c);
    line[i].X:=x;
    line[i].Y:=y;
  end;
  linecount:=cntp.VertexCount;
end;

procedure TPinsSelector.Calculate;
var
  I: Integer;
  ap1,ap2,lp1,lp2,ip,ip2:tm2point;
  a,b,c,aa,bb,cc,ml,l:extended;
  ps,rps:double;
  mq:IIngeoMapObjectsQuery;
  mobj:IIngeoMapObject;
  shp:IIngeoShape;
  cntp:IIngeoContourPart;
  larid,objid:widestring;
  spi:integer;
  j: Integer;
  vi: Integer;
  pp1,pp2:TM2Point;
  x1,y1,x2,y2,cv:double;
begin
  ml:=1e20;
  ps:=gAddon.MapView.SizeFromDevice(5);
  if linelar='' then
    exit;
  mq:=mobjs.QueryByRect(linelar,p1.X-ps,p1.Y-ps,p1.X+ps,p1.Y+ps,False);
  ml:=1e20;
  selectedobj:=nil;
  selectedcnt:=nil;
  selectedpnt:=-1;
  while not mq.EOF do
  begin
    mq.Fetch(larid,objid,spi);
    mobj:=mobjs.GetObject(objid);
    for i := 0 to mobj.Shapes.Count - 1 do
    begin
      if mobj.Shapes.Item[i].DefineGeometry then
      begin
        shp:=mobj.Shapes.Item[i];
        for j := 0 to shp.Contour.Count - 1 do
        begin
          cntp:=shp.Contour.Item[j];
          for vi := 0 to cntp.VertexCount - 1 do
          begin
            cntp.GetVertex(vi,x1,y1,cv);
            if (vi=(cntp.VertexCount-1)) then
            begin
              if cntp.Closed then
                cntp.GetVertex(0,x2,y2,cv) else break;
            end else
              cntp.GetVertex(vi+1,x2,y2,cv);
            if CalcPoint2(x1,y1,x2,y2,p1,ps,p2) then
            begin
              l:=SQRT(SQR(p1.X-p2.X)+SQR(p1.Y-p2.Y));
              if l<ml then
              begin
                selectedobj:=mobj;
                selectedcnt:=cntp;
                selectedpnt:=vi;
                ml:=l;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPinsSelector.CalcAngle(p1,p2:TM2Point): real;
var an:real;
begin
  an:=ArcTan2((p2.y-p1.y),(p2.x-p1.x));
  an:=an*360/(2*pi);
  if an<0 then an:=an+360;
  Result:=an;
end;

function TPinsSelector.CalcPoint(p:TM2Point;an,d:real):TM2Point;
var np:TM2Point;
begin
end;


function TPinsSelector.CalcPoint2(x1,y1,x2,y2:double;p:TM2Point;d:double;var res:TM2Point): boolean;
var lp1,lp2:TM2Point;
    a,b,c,aa,bb,cc,l:extended;
begin
  lp1.X:=x1;lp2.X:=x2;
  lp1.Y:=y1;lp2.Y:=y2;
     a:=lp1.y-lp2.Y;
     b:=-(lp1.X-lp2.X);
     c:=lp1.X*lp2.Y-lp2.X*lp1.Y;
     aa:=-b;
     bb:=a;
     //c=-ax-by;
     cc:=-aa*p1.X-bb*p1.Y;
     p2.X:=(b*cc-c*bb)/(a*bb-aa*b);
     p2.Y:=(c*aa-cc*a)/(a*bb-aa*b);
     if (p2.X<=max(lp1.X,lp2.X)) and (p2.X>=min(lp1.X,lp2.X)) and
        (p2.y<=max(lp1.y,lp2.y)) and (p2.y>=min(lp1.y,lp2.y)) then
     begin

       l:=sqrt(sqr(p.X-p2.X)+sqr(p.Y-p2.Y));
       if l<d then
       begin
         REsult:=True;
         res:=p2;
       end else REsult:=False;
     end else Result:=False;

end;

procedure TPinsSelector.Notification(AWhat: TM2EditorNotification);
begin
  if aWhat=enfViewChanged then
  //fNavigator.MapNavigated;
  inherited;
end;

end.
