unit coordconverter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DllForm;

type
  TfCoordConverter = class(TM2AddonForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    eSX1: TEdit;
    eSY1: TEdit;
    eSX2: TEdit;
    eSY2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    eDX1: TEdit;
    eDY1: TEdit;
    eDX2: TEdit;
    eDY2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    cbAllObjects: TCheckBox;
    Label7: TLabel;
    lParams: TLabel;
    ListBox1: TListBox;
    eSX3: TEdit;
    eSY3: TEdit;
    eDY3: TEdit;
    eDX3: TEdit;
    Label8: TLabel;
    cbKoeff: TCheckBox;
    Label9: TLabel;
    eA1: TEdit;
    Label10: TLabel;
    eB1: TEdit;
    Label11: TLabel;
    eC1: TEdit;
    Label12: TLabel;
    eA2: TEdit;
    Label13: TLabel;
    eB2: TEdit;
    Label14: TLabel;
    eC2: TEdit;
    cbReverse: TCheckBox;
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure Convert;
  public
    { Public declarations }
  end;
const rkey='\Software\AzSoft\TOPOUTILS\CoordConverter';
var
  fCoordConverter: TfCoordConverter;

implementation
uses addn,Ingeo_TLB, math, registry;
{$R *.dfm}

procedure TfCoordConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
var r:Tregistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(rkey,True);
  r.WriteString('sx1',eSX1.Text);
  r.WriteString('sx2',eSX2.Text);
  r.WriteString('sx3',eSX3.Text);
  r.WriteString('sy1',eSy1.Text);
  r.WriteString('sy2',eSy2.Text);
  r.WriteString('sy3',eSY3.Text);
  r.WriteString('dx1',edX1.Text);
  r.WriteString('dx2',edX2.Text);
  r.WriteString('dy1',edy1.Text);
  r.WriteString('dy2',edy2.Text);
  r.WriteString('dx3',eDX3.Text);
  r.WriteString('dy3',eDY3.Text);

  r.WriteString('a1',eA1.Text);
  r.WriteString('b1',eB1.Text);
  r.WriteString('c1',eC1.Text);
  r.WriteString('a2',eA2.Text);
  r.WriteString('b2',eB2.Text);
  r.WriteString('c2',eC2.Text);
  r.WriteBool('kf',cbKoeff.Checked);
  r.Free;
  Action:=caFree;
end;

procedure TfCoordConverter.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfCoordConverter.Button1Click(Sender: TObject);
begin
  Convert;
end;

procedure TfCoordConverter.Convert;
var sx1,sx2,sy1,sy2:double;
    dx1,dx2,dy1,dy2:double;
    nx,ny,sina,cosa,a1,a2,angle,dx,dy:double;
    nx2,ny2,dxx,dyy:double;
    mobjs:IIngeoMapObjects;
    obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    oi,si,vi,vvi,mi,li:integer;
    xx,yy,cv:double;
    mq:IIngeoMapObjectsQuery;
    lar:string;
    mp:IIngeoMap;
    vmp:IIngeoVectorMap;
    ilar,oidd:widestring;
    spi:integer;
    ca1,cb1,cc1,ca2,cb2,cc2:double;
    cci:integer;
begin
  if cbReverse.Checked then
  begin
    dx1:=StrToFloat(eSX1.Text);dy1:=StrToFloat(eSY1.Text);
    dx2:=StrToFloat(eSX2.Text);dy2:=StrToFloat(eSY2.Text);
    sx1:=StrToFloat(eDX1.Text);sy1:=StrToFloat(eDY1.Text);
    sx2:=StrToFloat(eDX2.Text);sy2:=StrToFloat(eDY2.Text);

  end else
  begin
    sx1:=StrToFloat(eSX1.Text);sy1:=StrToFloat(eSY1.Text);
    sx2:=StrToFloat(eSX2.Text);sy2:=StrToFloat(eSY2.Text);
    dx1:=StrToFloat(eDX1.Text);dy1:=StrToFloat(eDY1.Text);
    dx2:=StrToFloat(eDX2.Text);dy2:=StrToFloat(eDY2.Text);
  end;
  a1:=ArcTan2((sx1-sx2),(sy1-sy2));
  a2:=ArcTan2((dx1-dx2),(dy1-dy2));
  angle:=a2-a1;

  sina:=Sin(-angle);
  cosa:=Cos(-Angle);
  nx:=sx1*cosa-sy1*sina;
  ny:=sx1*sina+sy1*cosa;

  nx2:=sx2*cosa-sy2*sina;
  ny2:=sx2*sina+sy2*cosa;
  dxx:=dx2-nx2;
  dyy:=dy2-ny2;

  dx:=dx1-nx;
  dy:=dy1-ny;

  dx:=(dx+dxx)/2;
  dy:=(dy+dyy)/2;
  lParams.Caption:=Format('ddx=%f ddy=%f dx=%f dy=%f',[dxx-dx,dyy-dy,dx,dy]);

  if cbKoeff.Checked then
  begin
     ca1:=StrToFloat(eA1.Text);
     cb1:=StrToFloat(eB1.Text);
     cc1:=StrToFloat(eC1.Text);
     ca2:=StrToFloat(eA2.Text);
     cb2:=StrToFloat(eB2.Text);
     cc2:=StrToFloat(eC2.Text);

  end else
  begin
    ca1:=cosa;
    cb1:=-sina;
    cc1:=dx;
    ca2:=sina;
    cb2:=cosa;
    cc2:=dy;
  end;

  mobjs:=gAddon2.ActiveDb.MapObjects;
  if cbAllObjects.Checked then
  begin
  for oi:=0 to gAddon2.ActiveProjectView.MapViews.Count-1 do
  begin
    mp:=gAddon2.ActiveProjectView.MapViews.Item[oi].Map;
    if mp.MapType<>inmtVector then continue;
    vmp:=mp as IIngeoVectorMap;
    Label7.Caption:=Format('%d/%d',[oi,gAddon2.ActiveProjectView.MapViews.Count-1]);
    Application.ProcessMessages;
    for li:=0 to vmp.Layers.Count-1 do
    begin
    lar:=vmp.Layers.Item[li].ID;
    mq:=gAddon2.ActiveDb.MapObjects.QueryByLayers(lar);
    cci:=0;
    while not mq.EOF do
    begin
      mq.Fetch(ilar,oidd,spi);
      try
      obj:=mobjs.GetObject(oidd);
      for si:=0 to obj.Shapes.Count-1 do
      begin
        shp:=obj.Shapes.Item[si];
        for vi:=0 to shp.Contour.Count-1 do
        begin
          cntp:=shp.Contour.Item[vi];
          for vvi:=0 to cntp.VertexCount-1 do
          begin
            cntp.GetVertex(vvi,xx,yy,cv);
            nx:=xx*ca1+yy*cb1+cc1;
            ny:=xx*ca2+yy*cb2+cc2;
            cntp.SetVertex(vvi,nx,ny,cv);
          end; //vvi
        end; //vi
      end;  //si
      Inc( cci);
      if (cci mod 1000)=0 then
      begin
        mobjs.UpdateChanges;
        gAddon2.ProcessMessages;
      end;
      except
        on e:Exception do
        begin
           ListBox1.Items.Add('Ошибка конвертации '+oidd);
        end;
      end;
    end;  //while
    mobjs.UpdateChanges;
    end; //li
    end; //oi
  end else
  begin
  for oi:=0 to gAddon2.Selection.Count-1 do
  begin
    obj:=mobjs.GetObject(gAddon2.Selection.IDs[oi]);
    for si:=0 to obj.Shapes.Count-1 do
    begin
      shp:=obj.Shapes.Item[si];
      for vi:=0 to shp.Contour.Count-1 do
      begin
        cntp:=shp.Contour.Item[vi];
        for vvi:=0 to cntp.VertexCount-1 do
        begin
          cntp.GetVertex(vvi,xx,yy,cv);
          nx:=xx*ca1+yy*cb1+cc1;
          ny:=xx*ca2+yy*cb2+cc2;
          cntp.SetVertex(vvi,nx,ny,cv);
        end;//vvi
      end; //vi
    end;//si

    mobjs.UpdateChanges;
  end;  //oid
  end;

end;

procedure TfCoordConverter.FormCreate(Sender: TObject);
var r:Tregistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(rkey,True);
  if r.ValueExists('sx1') then eSX1.Text:=r.ReadString('sx1');
  if r.ValueExists('sx2') then eSX2.Text:=r.ReadString('sx2');
  if r.ValueExists('sy1') then eSy1.Text:=r.ReadString('sy1');
  if r.ValueExists('sy2') then eSy2.Text:=r.ReadString('sy2');

  if r.ValueExists('sx3') then eSx3.Text:=r.ReadString('sx3');
  if r.ValueExists('sy3') then eSy3.Text:=r.ReadString('sy3');

  if r.ValueExists('dx1') then edX1.Text:=r.ReadString('dx1');
  if r.ValueExists('dx2') then edX2.Text:=r.ReadString('dx2');
  if r.ValueExists('dy1') then edy1.Text:=r.ReadString('dy1');
  if r.ValueExists('dy2') then edy2.Text:=r.ReadString('dy2');

  if r.ValueExists('dx3') then edX3.Text:=r.ReadString('dx3');
  if r.ValueExists('dy3') then edy3.Text:=r.ReadString('dy3');

  if r.ValueExists('a1') then eA1.Text:=r.ReadString('a1');
  if r.ValueExists('b1') then eB1.Text:=r.ReadString('b1');
  if r.ValueExists('c1') then eC1.Text:=r.ReadString('c1');

  if r.ValueExists('a2') then eA2.Text:=r.ReadString('a2');
  if r.ValueExists('b2') then eB2.Text:=r.ReadString('b2');
  if r.ValueExists('c2') then eC2.Text:=r.ReadString('c2');

  if r.ValueExists('kf') then cbKoeff.Checked:=r.ReadBool('kf');

  r.Free;

end;

procedure TfCoordConverter.FormShow(Sender: TObject);
var r:Tregistry;
begin
  r:=TRegistry.Create;
  r.OpenKey(rkey,True);
  if r.ValueExists('sx1') then eSX1.Text:=r.ReadString('sx1');
  if r.ValueExists('sx2') then eSX2.Text:=r.ReadString('sx2');
  if r.ValueExists('sy1') then eSy1.Text:=r.ReadString('sy1');
  if r.ValueExists('sy2') then eSy2.Text:=r.ReadString('sy2');
  if r.ValueExists('dx1') then edX1.Text:=r.ReadString('dx1');
  if r.ValueExists('dx2') then edX2.Text:=r.ReadString('dx2');
  if r.ValueExists('dy1') then edy1.Text:=r.ReadString('dy1');
  if r.ValueExists('dy2') then edy2.Text:=r.ReadString('dy2');
  r.Free;

end;

procedure TfCoordConverter.Button3Click(Sender: TObject);
var zz:IIngeoMatrixProjection;
begin
//---------
  zz:=gAddon2.MainWindow.MapWindow.Surface.Projection as IIngeoMatrixProjection;
//  gAddon2.MainWindow.MapWindow.Surface.Projection.
  zz.AddRotation(0.5);

end;

end.
