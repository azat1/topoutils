unit podt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Ingeo_tLB,M2Addon,M2Addond;

type
  TfPodt = class(TForm)
    Button1: TButton;
    Button2: TButton;
    leLarName: TLabeledEdit;
    Button3: TButton;
    leDist: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    sellar:string;
    gmobjs:IIngeoMapObjects;
    procedure MakeWork;
    procedure MakePodt(x,y:double);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPodt: TfPodt;

implementation
uses addn,selstyle;
{$R *.dfm}

procedure TfPodt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfPodt.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfPodt.Button1Click(Sender: TObject);
begin
  MakeWork;
end;

procedure TfPodt.MakeWork;
var oi,si,vi,ci:integer;
    obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    x,y,cv:double;
begin
  gmobjs:=gAddon2.ActiveDb.MapObjects;
  for oi:=0 to gAddon2.Selection.Count-1 do
  begin
    obj:=gmobjs.GetObject(gAddon2.Selection.IDs[oi]);
    for si:=0 to obj.Shapes.Count-1 do
    begin
      shp:=obj.Shapes.Item[si];
      if not shp.DefineGeometry then continue;
      for ci:=0 to shp.Contour.Count-1 do
      begin
        cntp:=shp.Contour.Item[ci];
        for vi:=0 to cntp.VertexCount-1 do
        begin
          cntp.GetVertex(vi,x,y,cv);
          MakePodt(x,y);
        end;
      end;
    end;
  end;
  gmobjs.UpdateChanges;
end;

procedure TfPodt.Button3Click(Sender: TObject);

var f:TfSelectStyle;
    lar,stl:string;
    llar:IIngeoLayer;
begin
  f:=TfSelectStyle.Create(self);
  if f.ShowModal=mrOk then
  begin
    stl:=PM2ID(f.trv1.Selected.Data)^;
    llar:=gAddon2.ActiveDb.StyleFromID(stl).Layer;
    leLarName.Text:=llar.Map.Name+'\'+llar.Name;
    sellar:=llar.ID;
  end;
  f.Free;
end;

procedure TfPodt.FormShow(Sender: TObject);
begin
  Windows.SetParent(Handle,gAddon2.MainWindow.Handle);
end;

procedure TfPodt.MakePodt(x, y: double);
var dx:double;
    mq:IIngeoMapObjectsQuery;
    ilar,iobj:widestring;
    i,spi,si,ci,vi,idc:integer;
    obj:IIngeoMapObject;
    shp:IIngeoShape;
    cntp:IIngeoContourPart;
    wx,wy,wcv,l:double;
    idlist:IM2IDsList;
    oid:TM2ID;
begin
  dx:=StrToFloat(leDist.Text);
  idlist:=gAddon.MapObjects.FindIntersectedObjects(sellar,False,M2REct(x-dx,y-dx,x+dx,y+dx),False);
//  mq:=gAddon2.ActiveDb.MapObjects.QueryByRect(sellar,x-dx,y-dx,x+dx,y+dx,False);
  idlist.i_GetCount(idc);
  for i:=0 to idc-1 do
  begin
//    mq.Fetch(ilar,iobj,spi);
    idlist.i_GetItem(i,oid);
    obj:=gmobjs.GetObject(oid);
    for si:=0 to obj.Shapes.Count-1 do
    begin
      shp:=obj.Shapes.Item[si];
      if not shp.DefineGeometry then continue;
      for ci:=0 to shp.Contour.Count-1 do
      begin
        cntp:=shp.Contour.Item[ci];
        for vi:=0 to cntp.VertexCount-1 do
        begin
          cntp.GetVertex(vi,wx,wy,wcv);
          l:=SQRT(SQR(x-wx)+SQR(y-wy));
          if l<dx then
          begin
            cntp.SetVertex(vi,x,y,wcv);
          end;
        end;
      end;
    end;
  end;
end;

end.
