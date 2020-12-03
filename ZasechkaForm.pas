unit ZasechkaForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Ingeo_TLB, InScripting_TLB, dllform;

type
  TfZasechka = class(TM2AddonForm)
    Label1: TLabel;
    eX1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    eY1: TEdit;
    Label4: TLabel;
    eL1: TEdit;
    Label5: TLabel;
    eX2: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    eY2: TEdit;
    Label8: TLabel;
    eL2: TEdit;
    bSel1: TButton;
    bSel2: TButton;
    bMake1: TButton;
    bMake2: TButton;
    procedure FormShow(Sender: TObject);
    procedure bSel1Click(Sender: TObject);
    procedure bSel2Click(Sender: TObject);
    procedure eL1Change(Sender: TObject);
    procedure bMake1Click(Sender: TObject);
    procedure bMake2Click(Sender: TObject);
  private
    app:IIngeoApplication;
    px1,px2,py1,py2,x1,y1,x2,y2:double;
    { Private declarations }
    procedure PreloadPoints;
    procedure GetXY(id:string;var x,y:double);
    procedure CalcPoints;
    procedure DrawCalc;
    procedure MakePoint(x,y:double);
    function GetStyle:string;
  public
    constructor Create(app:IIngeoApplication);
    { Public declarations }
  end;

var
  fZasechka: TfZasechka;
procedure MakeZasechka(app:IIngeoApplication);

implementation

{$R *.dfm}

procedure MakeZasechka(app:IIngeoApplication);
var f:TfZasechka;
begin
  f:=TfZasechka.Create(app);
  f.Show;
  //f.Free;
end;
{ TfZasechka }

procedure TfZasechka.bMake1Click(Sender: TObject);
begin
  MakePoint(px1,py1);
end;

procedure TfZasechka.bMake2Click(Sender: TObject);
begin
  MakePoint(px2,py2);
end;

procedure TfZasechka.bSel1Click(Sender: TObject);
var x,y:double;
begin
  if app.Selection.Count>0 then
  begin
    GetXY(app.Selection.IDs[0],x,y);
    eX1.Text:=Format('%.4f',[x]);
    eY1.Text:=Format('%.4f',[y]);
  end;
end;

procedure TfZasechka.bSel2Click(Sender: TObject);
var x,y:double;
begin
  if app.Selection.Count>0 then
  begin
    GetXY(app.Selection.IDs[0],x,y);
    eX2.Text:=Format('%.4f',[x]);
    eY2.Text:=Format('%.4f',[y]);
  end;
end;

procedure TfZasechka.CalcPoints;
var l1,l2,x1,y1,x2,y2,b1,q1,s6,s7,r1,t1,h1_1,h1_2,dx,dy:double;
begin
  try
    l1:=StrToFloat(eL1.Text);
    l2:=StrToFloat(eL2.Text);
    x1:=StrToFloat(eX1.Text);
    x2:=StrToFloat(eX2.Text);
    y1:=StrToFloat(eY1.Text);
    y2:=StrToFloat(eY2.Text);
    s6:=l1;
    s7:=l2;
    b1:=SQRT(SQR(x1-x2)+SQR(y1-y2));
    r1:=s6/b1;
    t1:=s7/b1;

    q1:=0.5*(1+r1*r1-t1*t1);
    h1_1:=SQRT(r1*r1-q1*q1);
    h1_2:=-SQRT(r1*r1-q1*q1);
    dx:=q1*(x2-x1)+h1_1*(y2-y1);
    px1:=x1+dx;
    dy:=q1*(y2-y1)-h1_1*(x2-x1);
    py1:=y1+dy;

    dx:=q1*(x2-x1)+h1_2*(y2-y1);
    px2:=x1+dx;
    dy:=q1*(y2-y1)-h1_2*(x2-x1);
    py2:=y1+dy;
    self.x1:=x1;
    self.x2:=x2;
    self.y1:=y1;
    self.y2:=y2;

    DrawCalc;

  except

  end;
end;

constructor TfZasechka.Create(app: IIngeoApplication);
begin
 inherited Create(nil);
 self.app:=app;
end;

procedure TfZasechka.DrawCalc;
var
  surf: IIngeoPaintSurface;
  cntr:IIngeoContour;
  cntp: IIngeoContourPart;
begin
 // app.MainWindow.MapWindow.Invalidate;
  surf:=app.MainWindow.MapWindow.Surface;
  cntr:=app.CreateObject(inocContour,0) as IIngeoContour;
  cntp:= cntr.Insert(-1);
  cntp.InsertVertex(-1,x1,y1,0);
  cntp.InsertVertex(-1,px1,py1,0);
  cntp.InsertVertex(-1,x2,y2,0);
  cntp.Closed:=true;
  surf.Pen.Style:=inpsSolid;
  surf.Pen.Color:=clRed;
  surf.Pen.WidthInMM:=1;
  surf.Pen.ForZoomScale:=0;
  surf.Brush.Style:=inbsClear;
  surf.PaintContour(cntr,true);
  cntp.Clear;
  cntp.InsertVertex(-1,x1,y1,0);
  cntp.InsertVertex(-1,px2,py2,0);
  cntp.InsertVertex(-1,x2,y2,0);
  surf.Pen.Style:=inpsSolid;
  surf.Pen.Color:=clBlue;
  surf.Pen.WidthInMM:=1;
  surf.Pen.ForZoomScale:=0;
  surf.PaintContour(cntr,true);

end;

procedure TfZasechka.eL1Change(Sender: TObject);
begin
  CalcPoints;
end;

procedure TfZasechka.FormShow(Sender: TObject);
begin
  if app.Selection.Count>0 then
  begin
    PreloadPoints();
  end;
end;

function TfZasechka.GetStyle: string;
var
  mobj: IIngeoMapObject;
begin
  if app.Selection.Count>0 then
  begin
    mobj:=app.ActiveDb.MapObjects.GetObject(app.Selection.IDs[0]);
    REsult:=mobj.Shapes[0].StyleID;
    exit;
  end;
  Result:=app.ActiveProjectView.ActiveLayerView.Layer.Styles[0].ID;
end;

procedure TfZasechka.GetXY(id: string; var x, y: double);
var
  mobj: IIngeoMapObject;
  cv:double;
begin
  mobj:=app.ActiveDb.MapObjects.GetObject(id);
  mobj.Shapes[0].Contour[0].GetVertex(0,x,y,cv);
end;

procedure TfZasechka.MakePoint(x, y: double);
var mobjs:IIngeoMapObjects;
    mobj:IIngeoMapObject;
    lar,stl:string;
  shp: IIngeoShape;
  cntr: IIngeoContourPart;
begin
  lar:=app.ActiveProjectView.ActiveLayerView.Layer.ID;
  stl:=GetStyle;
  mobjs:=app.ActiveDb.MapObjects;
  mobj:=mobjs.AddObject(lar);
  shp:=mobj.Shapes.Insert(-1,stl);
  cntr:=shp.Contour.Insert(-1);
  cntr.InsertVertex(-1,x,y,0);
  mobjs.UpdateChanges;
end;

procedure TfZasechka.PreloadPoints;
var
  i: Integer;
  x,y:double;
begin
  GetXY(app.Selection.IDs[0],x,y);
  eX1.Text:=Format('%.4f',[x]);
  eY1.Text:=Format('%.4f',[y]);
  if app.Selection.Count>1 then
  begin
    GetXY(app.Selection.IDs[1],x,y);
    eX2.Text:=Format('%.4f',[x]);
    eY2.Text:=Format('%.4f',[y]);
  end;
end;

end.
