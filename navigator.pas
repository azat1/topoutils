unit navigator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, addn, medit;

type
  TfNavigator = class(TForm)
    imMain: TImage;
    Panel1: TPanel;
    sbCenter: TSpeedButton;
    cbScale: TComboBox;
    procedure sbCenterClick(Sender: TObject);
    procedure imMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cbScaleChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    centerx,centery,lscale:double;
    fbmp:TBitmap;
    editor:TPointSelector;
    procedure InitNavigator;
    procedure UpdateScreen;
    procedure SaveParams;
    procedure MapNavigated;
    procedure SetZoomCenter(x,y:integer);
    { Public declarations }
  end;

var
  fNavigator: TfNavigator;

implementation

uses Ingeo_TLB;

{$R *.dfm}

procedure TfNavigator.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gAddon.MapView.RemoveEditor(editor.IEditor);
  editor.Free;
  editor:=nil;
  SaveParams;
  Action:=caFree;
  fNavigator:=nil;
end;

procedure TfNavigator.InitNavigator;
begin
  Windows.SetParent(Handle,gAddon2.MainWindow.Handle);
  fBmp:=TBitmap.Create;
  cbScale.Text:=gAddon2.UserProfile.Get(inupUser,'','topoutils_nav_scale','10000');
  UpdateScreen;
//  gAddon2.MainWindow.MapWindow.Surface.Projection.ZoomScale;
end;

procedure TfNavigator.SaveParams;
begin
  gAddon2.UserProfile.Put(inupUser,'','topoutils_nav_scale',cbScale.Text);
end;

procedure TfNavigator.UpdateScreen;
var rx,ry:integer;
    cx,cy,scale:double;
    fn:string;
    nnav:IIngeoMatrixProjectionNavigator;
begin
  fn:=ExtractFilePath( ParamStr(0))+'navtmp.bmp';
//  Canvas.
  nnav:=Gaddon2.MainWindow.MapWindow.Surface.Navigator as IIngeoMatrixProjectionNavigator;
  rx:=Screen.PixelsPerInch;
  ry:=Screen.PixelsPerInch;
  scale:=1/StrToFloat(cbScale.Text);
  lscale:=scale;
  cx:=nnav.CenterX;
  cy:=nnav.CenterY;
//  gAddon2.MainWindow.MapWindow.Surface.Projection.
  GAddon2.ActiveProjectView.MakeImageFile(rx,ry,imMain.Width,imMain.Height,
                                          cx,cy,scale,90,True,clWhite,fn);
//  fBmp.Free;
  fBmp.LoadFromFile(fn);
  imMain.Picture.Bitmap.Assign(fBmp);//.Draw(0,0,fBmp);

  imMain.Repaint;
//  fBmp.Free;
  centerx:=cx;
  centery:=cy;
  MapNavigated;
end;

procedure TfNavigator.FormShow(Sender: TObject);
begin
  editor:=TPointSelector.Create(gAddon);
  gAddon.MapView.AddEditor(editor.IEditor);
  InitNavigator;
end;

procedure TfNavigator.cbScaleChange(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TfNavigator.SpeedButton1Click(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TfNavigator.MapNavigated;
var ccx,ccy,x1,y1,x2,y2,wx,wy:double;
    dx,dy,sx,sy,pcx,pcy:Integer;
    nnav:IIngeoMatrixProjectionNavigator;
begin
  nnav:=Gaddon2.MainWindow.MapWindow.Surface.Navigator as IIngeoMatrixProjectionNavigator;
  dx:=gAddon2.MainWindow.MapWindow.Surface.DeviceRight;
  dy:=gAddon2.MainWindow.MapWindow.Surface.DeviceBottom;
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(0,0,x1,y1);
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(dx,dy,x2,y2);
  wx:=x1-x2;
  wy:=y2-y1;
  ccx:=nnav.CenterX;
  ccy:=nnav.CenterY;
  ccx:=centerx-ccx;
  ccy:=centery-ccy;
  dx:=-Round( ccy*lscale/0.0254*Screen.PixelsPerInch);
  dy:=Round(ccx*lscale/0.0254*Screen.PixelsPerInch);
  sx:=Round(wy*lscale/0.0254*Screen.PixelsPerInch);
  sy:=Round(wx*lscale/0.0254*Screen.PixelsPerInch);
  imMain.Picture.Bitmap.Canvas.Draw(0,0,fbmp);
  with imMain.Picture.Bitmap.Canvas do
  begin
    pcx:=fBmp.Width div 2;
    pcy:=fBmp.Height div 2;

    Pen.Color:=clRed;
    Pen.Style:=psSolid;
    Pen.Width:=1;
    Brush.Style:=bsclear;
    Rectangle(pcx+dx-sx div 2,pcy+dy-sy div 2,pcx+dx+sx div 2,pcy+dy+sy div 2);
  end;
  imMain.Repaint;
end;

procedure TfNavigator.imMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then
  begin
    SetZoomCenter(x,y);
  end;
end;

procedure TfNavigator.SetZoomCenter(x, y: integer);
var wx,wy:double;
    pcx,pcy:integer;
    nnav:IIngeoMatrixProjectionNavigator;
begin
  nnav:=Gaddon2.MainWindow.MapWindow.Surface.Navigator as IIngeoMatrixProjectionNavigator;
  pcx:=fBmp.Width div 2;
  pcy:=fBmp.Height div 2;
  wx:=(pcy-y)/Screen.PixelsPerInch*0.0254/lscale;
  wy:=(pcx-x)/Screen.PixelsPerInch*0.0254/lscale;
  gAddon2.MainWindow.MapWindow.Navigator.Navigate(centerx+wx,centery-wy,
                          nnav.ZoomScale);
end;

procedure TfNavigator.sbCenterClick(Sender: TObject);
begin
  InitNavigator;
end;

end.
