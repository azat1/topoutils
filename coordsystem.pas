unit coordsystem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XMLIntf, XMLDoc, Ingeo_TLB;

type
  TfCoordSystem = class(TForm)
    Label1: TLabel;
    cbSource: TComboBox;
    cbDest: TComboBox;
    Label2: TLabel;
    rgWhat: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    lbErrs: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  protected
    doc:IXMLDocument;
    mnode:IXMLNode;
    fn:string;

    procedure LoadParams;
    procedure SaveParams;
    procedure LoadCbs;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCoordSystem: TfCoordSystem;

implementation
uses coordsystemlist, addn, utmclass, fcoordeditor;
{$R *.dfm}

procedure TfCoordSystem.Button1Click(Sender: TObject);
var objs:TStringList;
  i: Integer;
  map:IIngeoMap;
  vmap:IIngeoVectorMap;
  li: Integer;
  layer: IIngeoLayer;
  mq:IIngeoMapObjectsQuery;
  lid: widestring;
  oid: widestring;
  spi: Integer;
  source,dest:TUTMConverter;
  nd: IXMLNode;
  dtc: TDatumConverter;
  mobjs:IIngeoMapObjects;
  mobj:IIngeoMapObject;
  shp:IIngeoShape;
  cntp:IIngeoContourPart;
  wx,wy,wc:Double;
  si: Integer;
  ci: Integer;
  vi: Integer;
  cv: double;
  lat: Extended;
  lon: Extended;
  dy: Extended;
  dx: Extended;
  dlat: Extended;
  dlon: Extended;

begin
  case rgWhat.ItemIndex of
  -1:begin
       ShowMessage('НЕ выбраны объекты!');
       exit;
     end;
   0:begin
       objs:=TStringList.Create;
       for i := 0 to gAddon2.Selection.Count - 1 do
       begin
         objs.Add(gAddon2.Selection.IDs[i]);
       end;
     end;
   1:begin
       objs:=TStringList.Create;
       for i:=0 to gAddon2.ActiveProjectView.MapViews.Count-1 do
       begin
         map:=gAddon2.ActiveProjectView.MapViews.Item[i].Map;
         if map.MapType=inmtVector then
         begin
           vmap:=map as IIngeoVectorMap;
           for li := 0 to vmap.Layers.Count - 1 do
           begin
              layer:=vmap.Layers.Item[li];
              mq:=gAddon2.ActiveDb.MapObjects.QueryByLayers(layer.ID);
              while not mq.EOF do
              begin
                mq.Fetch(lid,oid,spi);
                objs.Add(oid);
              end;
           end;

         end;
       end;
     end;
   2:begin
       objs:=TStringList.Create;

       //for i:=0 to gAddon2.ActiveProjectView.MapViews.Count-1 do
       //begin
         //map:=gAddon2.ActiveProjectView.MapViews.Item[i].Map;
         //if map.MapType=inmtVector then
         //begin
         //  vmap:=map as IIngeoVectorMap;
          // for li := 0 to vmap.Layers.Count - 1 do
          // begin
              layer:=gAddon2.ActiveProjectView.ActiveLayerView.Layer;// vmap.Layers.Item[li];
              mq:=gAddon2.ActiveDb.MapObjects.QueryByLayers(layer.ID);
              while not mq.EOF do
              begin
                mq.Fetch(lid,oid,spi);
                objs.Add(oid);
              end;
     //      end;

       //  end;
      // end;
     end;
    3:begin
       objs:=TStringList.Create;
     //  for i:=0 to gAddon2.ActiveProjectView.MapViews.Count-1 do
     //  begin
         map:=gAddon2.ActiveProjectView.ActiveMapView.Map;// MapViews.Item[i].Map;
         if map.MapType=inmtVector then
         begin
           vmap:=map as IIngeoVectorMap;
           for li := 0 to vmap.Layers.Count - 1 do
           begin
              layer:=vmap.Layers.Item[li];
              mq:=gAddon2.ActiveDb.MapObjects.QueryByLayers(layer.ID);
              while not mq.EOF do
              begin
                mq.Fetch(lid,oid,spi);
                objs.Add(oid);
              end;
           end;

         end;
       //end;
     end;

  end;
    if cbSource.ItemIndex=-1 then
  begin
    ShowMessage('Не выбран тип исходных координат!');
    exit;
  end;
  if cbDest.ItemIndex=-1 then
  begin
    ShowMessage('Не выбран тип конечных координат!');
    exit;
  end;

    nd:=mnode.ChildNodes.Get(cbSource.ItemIndex);
    source:=TUTMConverter.Create(nd.GetAttributeNS('Datum',''),
                               StrtoAngle( nd.GetAttributeNS('CM','')),
                               nd.GetAttributeNS('FY',''),
                               nd.GetAttributeNS('FX',''),
                               nd.GetAttributeNS('Scale',''));

  nd:=mnode.ChildNodes.Get(cbDest.ItemIndex);
  dest:=TUTMConverter.Create(nd.GetAttributeNS('Datum',''),
                               StrtoAngle( nd.GetAttributeNS('CM','')),
                               nd.GetAttributeNS('FY',''),
                               nd.GetAttributeNS('FX',''),
                               nd.GetAttributeNS('Scale',''));
  dtc:=TDatumConverter.Create(source.datum,dest.datum);
  mobjs:=gAddon2.ActiveDb.MapObjects;
  for i := 0 to objs.Count - 1 do
  begin
    try

    mobj:=mobjs.GetObject(objs[i]);
    for si := 0 to mobj.Shapes.Count - 1 do
    begin
      shp:=mobj.Shapes.Item[si];
      for ci := 0 to shp.Contour.Count - 1 do
      begin
        cntp:=shp.Contour.Item[ci];
        for vi := 0 to cntp.VertexCount - 1 do
        begin
          cntp.GetVertex(vi,wx,wy,cv);
          source.XY2LatLon(wy,wx,lat,lon);
          dtc.Convert(lat,lon,dlat,dlon);
          dest.LatLon2XY(dlat,dlon,dy,dx);
          cntp.SetVertex(vi,dx,dy,cv);
        end;
      end;
    end;
    except
      on e:Exception do
      begin
        lbErrs.Items.Add('Ошибка преобразования объекта!'+objs[i]);
      end;

    end;
    if (i mod 100)=0 then mobjs.UpdateChanges;
  end;
  mobjs.UpdateChanges;
  lbErrs.Items.Add('Завершено!');
end;

procedure TfCoordSystem.Button2Click(Sender: TObject);
var f:TfCoordSystemList;
begin
  f:=TfCoordSystemList.Create(self);
  f.node:=mnode;
  f.ShowModal;
  f.Free;
  LoadCbs;
end;

procedure TfCoordSystem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveParams;
end;

procedure TfCoordSystem.FormShow(Sender: TObject);
begin
  LoadParams;
end;

procedure TfCoordSystem.LoadCbs;
var
  i: Integer;
  nd:IXMLNode;
begin
  cbSource.Items.Clear;
  for i := 0 to mnode.ChildNodes.Count - 1 do
  begin
    nd:=mnode.ChildNodes.Get(i);
    cbSource.Items.Add(nd.GetAttributeNS('Name',''));
  end;
  cbDest.Items:=cbSource.Items;
end;

procedure TfCoordSystem.LoadParams;
begin
  fn:=ExtractFilePath(ParamStr(0))+'params.xml';
  if FileExists(fn) then
  begin
    doc:=LoadXMLDocument(fn);
    mnode:=doc.ChildNodes.FindNode('coordconverter');
  end else
  begin
    doc:=NewXMLDocument();
    mnode:=doc.AddChild('coordconverter');
  end;
  LoadCBs;
end;

procedure TfCoordSystem.SaveParams;
begin
  doc.SaveToFile(fn);
end;

end.
