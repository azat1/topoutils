unit cpwindow;

interface
uses Windows, dialogs;
const
  root='in_copywindow';
  lar='lar';
  obj='obj';
  shp='shp';
  sdata='sdata';
  cntr='cntr';
  cntrp='cntrp';
  attr_id='objid';
  attr_lar='larid';
  attr_stl='stlid';
procedure CopyWindow;
procedure PasteWindow;
procedure PasteWindowNoCheck;


implementation
uses classes,addn,Clipbrd,Ingeo_TLB, XMLIntf, XMLDoc, provider, cpreport;

var errreport:TStringList;

function CheckObject(objnode:IXMlNode;mnode:IXMLNode):boolean;
var mobj:IIngeoMapObject;
    objid:string;
    cx1,cy1,x1,y1,x2,y2:double;
begin
  objid:=objnode.GetAttributeNS(attr_id,'');
  if not gAddon2.ActiveDb.MapObjects.IsObjectExists(objid) then
  begin
    REsult:=False;
    exit;
  end;
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(objid);
  if mobj.LayerID<>objnode.GetAttributeNS(attr_lar,'') then
  begin
    REsult:=False;
    exit;
  end;
  cx1:=(mobj.X1+mobj.X2)/2;
  cy1:=(mobj.y1+mobj.y2)/2;
  x1:=mnode.GetAttributeNS('X1','');
  y1:=mnode.GetAttributeNS('Y1','');
  x2:=mnode.GetAttributeNS('X2','');
  y2:=mnode.GetAttributeNS('Y2','');
  if (cx1>x2) or (cx1<x1) or (cy1>y2) or (cy1<y1) then
  begin
    REsult:=False;
    exit;
  end;
  REsult:=True;

//  if cx1 then

end;

procedure   UpdateSemData(mobj:IIngeoMapObject;objnode:IXMLNode);
var sdatanode,recnode:IXMLNode;
  i,ri: Integer;
begin
  sdatanode:=objnode.ChildNodes.FindNode('sdata');
  for i := 0 to sdatanode.ChildNodes.Count - 1 do
  begin
    recnode:=sdatanode.ChildNodes.Get(i);
    if recnode.GetAttributeNS('lt','')=0 then
    begin
      mobj.SemData.SetValue(recnode.GetAttributeNS('table',''),
        recnode.GetAttributeNS('field',''),recnode.GetAttributeNS('value',''),0);

    end else
    begin
      ri:=mobj.SemData.AddRec(recnode.GetAttributeNS('table',''));
      mobj.SemData.SetValue(recnode.GetAttributeNS('table',''),
        recnode.GetAttributeNS('field',''),recnode.GetAttributeNS('value',''),ri);
    end;
  end;
end;

procedure UpdateObject(mobjs:IIngeoMapObjects;objnode:IXMLNode);
var mobj:IIngeoMapObject;
    cntp:IIngeoContourPart;
    shp:IIngeoShape;
    x,y,cv:double;
    larid,stlid:string;
  I: Integer;
  shpnode,shpsnode,cntrpnode,vnode:IXMLNode;
  ci: Integer;
  vi: Integer;
begin
//  larid:=objnode.GetAttributeNS(attr_lar,'');
  mobj:=mobjs.GetObject(objnode.GetAttributeNS(attr_id,''));
  mobj.Shapes.Clear;
  shpsnode:=objnode.ChildNodes.FindNode('shps');
  for I := 0 to shpsnode.ChildNodes.Count - 1 do
  begin
    shpnode:=shpsnode.childnodes.Get(i);
    stlid:=shpnode.GetAttributeNS(attr_stl,'');
    if not gAddon2.ActiveDb.StyleExists(stlid) then
    begin
       errreport.Add('Стиль не найден styleid='+stlid+', objid='+mobj.ID);
       continue;
    end;
    shp:=mobj.Shapes.Insert(-1,stlid);
    for ci := 0 to shpnode.ChildNodes.Count - 1 do
    begin
      cntrpnode:=shpnode.ChildNodes.Get(ci);
      cntp:=shp.Contour.Insert(-1);
      cntp.Closed:=cntrpnode.GetAttributeNS('closed','');
      for vi := 0 to cntrpnode.ChildNodes.Count - 1 do
      begin
        vnode:=cntrpnode.ChildNodes.Get(vi);
        cntp.InsertVertex(-1,vnode.GetAttributeNS('X',''),
           vnode.GetAttributeNS('Y',''),vnode.GetAttributeNS('C',''));
      end;
    end;
  end;
  UpdateSemData(mobj,objnode);
end;

procedure CreateOneObject(mobjs:IIngeoMapObjects;objnode:IXMLNode);
var mobj:IIngeoMapObject;
    cntp:IIngeoContourPart;
    shp:IIngeoShape;
    x,y,cv:double;
    larid,stlid:string;
  I: Integer;
  shpnode,shpsnode,cntrpnode,vnode:IXMLNode;
  ci: Integer;
  vi: Integer;
begin
  larid:=objnode.GetAttributeNS(attr_lar,'');
  if not gAddon2.ActiveDb.StyleExists(stlid) then
  begin
       errreport.Add('Слой  не найден layerid='+larid);
       exit;
  end;
  if mobjs.IsObjectExists(larid)   then
      mobj:=mobjs.AddObject(larid) else
        mobj:=mobjs.AddObjectWithID(larid,objnode.GetAttributeNS(attr_id,''));

  shpsnode:=objnode.ChildNodes.FindNode('shps');
  for I := 0 to shpsnode.ChildNodes.Count - 1 do
  begin
    shpnode:=shpsnode.childnodes.Get(i);
    stlid:=shpnode.GetAttributeNS(attr_stl,'');
    if not gAddon2.ActiveDb.StyleExists(stlid) then
    begin
       errreport.Add('Стиль не найден styleid='+stlid+', objid='+mobj.ID);
       continue;
    end;

    shp:=mobj.Shapes.Insert(-1,stlid);
    for ci := 0 to shpnode.ChildNodes.Count - 1 do
    begin
      cntrpnode:=shpnode.ChildNodes.Get(ci);
      cntp:=shp.Contour.Insert(-1);
      cntp.Closed:=cntrpnode.GetAttributeNS('closed','');
      for vi := 0 to cntrpnode.ChildNodes.Count - 1 do
      begin
        vnode:=cntrpnode.ChildNodes.Get(vi);
        cntp.InsertVertex(-1,vnode.GetAttributeNS('X',''),
           vnode.GetAttributeNS('Y',''),vnode.GetAttributeNS('C',''));
      end;
    end;
  end;

  UpdateSemData(mobj,objnode);
end;

procedure PasteWindowNoCheck;
var xm:IXMLDocument;
    mnode,objnode,shpsnode:IXMLNode;
  i: Integer;
  mobjs:IIngeoMapObjects;
begin
  if not Clipboard.HasFormat(CF_TEXT) then
  begin
    ShowMessage('Буфер обмена не содержит данных!');
    exit;
  end;
  xm:=NewXMLDocument;
  xm.LoadFromXML(Clipboard.AsText);
  mnode:=xm.ChildNodes.FindNode(root);
  if mnode=nil then
  begin
    ShowMessage('Буфер обмена не содержит скопированных данных!');
    exit;
  end;
  if MessageDlg('Внимание! Вставка может привести к дублированию объектов! Продолжить?',
     dialogs.mtConfirmation,[mbYes,mbNo],0)=ID_NO then exit;
  errreport:=TStringList.Create;
  mobjs:=gAddon2.ActiveDb.MapObjects;
//  shpsnode:=mnode.ChildNodes.F
  for i := 0 to mnode.ChildNodes.Count - 1 do
  begin
    objnode:=mnode.ChildNodes.Get(i);
    CreateOneObject(mobjs,objnode);
  end;
  mobjs.UpdateChanges;
  if errreport.Count>0 then
  begin
    fCpReport:=TfCpReport.Create(nil);
    fCpReport.Memo1.Lines:=errreport;
    fcpReport.Show;
  end;
  errreport.Free;
end;

procedure CopyLayer(node:IXMLNode;x1,y1,x2,y2:double;lar:IIngeoLayer);
begin

end;

procedure AddSemData(node:IXMLNode;mobj:IIngeoMapObject);
var lar:IIngeoLayer;
  t: Integer;
  st:IIngeoSemTable;
  fi: Integer;
  snode,fnode:IXMLNode;
  value:OleVariant;
  rcount:integer;
  ri: Integer;
begin
  lar:=gAddon2.ActiveDb.LayerFromID(mobj.LayerID);
  snode:=node.AddChild(sdata);
  for t := 0 to lar.SemTables.Count  - 1 do
  begin
    st:=lar.SemTables.Item[t];
    if st.LinkType=0 then
    begin
      for fi := 0 to st.FieldInfos.Count - 1 do
      begin
        if st.FieldInfos.Item[fi].FieldName='ID' then continue;
        fnode:=snode.AddChild('REC');
        fnode.SetAttributeNS('lt','',st.LinkType);
        value:=mobj.SemData.GetValue(st.Name,st.FieldInfos.Item[fi].FieldName,0);
        fnode.SetAttributeNS('table','',st.Name);
        fnode.SetAttributeNS('field','',st.FieldInfos.Item[fi].FieldName);

        fnode.SetAttributeNS('value','',value);
      end;
    end else
    begin
      for fi := 0 to st.FieldInfos.Count - 1 do
      begin
        for ri := 0 to rCount - 1 do
        begin
          if st.FieldInfos.Item[fi].FieldName='ID' then continue;
          fnode:=snode.AddChild('REC');
          fnode.SetAttributeNS('lt','',st.LinkType);
          rcount:=mobj.SemData.GetRecCount(st.Name);
          value:=mobj.SemData.GetValue(st.Name,st.FieldInfos.Item[fi].FieldName,ri);
          fnode.SetAttributeNS('table','',st.Name);
          fnode.SetAttributeNS('field','',st.FieldInfos.Item[fi].FieldName);
          fnode.SetAttributeNS('value','',value);
        end;
      end;
    end;
  end;
end;

procedure AddObject(mnode:IXMLNode;objid:string);
var cntrpnode,shpsnode,vnode,objnode,shapenode:IXMLNode;
    mobj:IIngeoMapObject;
    i: Integer;
    shape:IIngeoShape;
    ci: Integer;
    cntrpart:IIngeoContourPart;
    x,y,cv:double;
  vi: Integer;
begin
  objNode:=mnode.AddChild(obj);
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(objid);
  //mobj.LayerID
  objnode.SetAttributeNS(attr_id,'',objid);
  objnode.SetAttributeNS(attr_lar,'',  mobj.LayerID);
  shpsnode:=objnode.AddChild('shps');
  for i := 0 to mobj.Shapes.Count - 1 do
  begin
    shape:=mobj.Shapes.Item[i];
    shapenode:=shpsnode.AddChild(shp);
    shapenode.SetAttributeNS(attr_stl,'',shape.StyleID);
    for ci := 0 to shape.Contour.Count - 1 do
    begin
      cntrpart:=shape.Contour.Item[ci];
      cntrpnode:= shapenode.AddChild(cntrp);
      cntrpnode.SetAttributeNS('closed','',cntrpart.Closed);
      for vi := 0 to cntrpart.VertexCount - 1 do
      begin
        cntrpart.GetVertex(vi,x,y,cv);
        vnode:=cntrpnode.AddChild('p');
        vnode.SetAttributeNS('X','',x);
        vnode.SetAttributeNS('Y','',y);
        vnode.SetAttributeNS('C','',cv);
      end;
    end;
  end;
  AddSemData(objnode,mobj);
end;

procedure CopyWindow;
var xm:IXMLDocument;
    mnode:IXMLNode;
    mapv:IIngeoMapViews;
    map:IIngeoVectorMap;
    lar:IIngeoLayer;
  i: Integer;
  li: Integer;
  x1,y1,x2,y2:double;
  strl:TStringList;
  arr:OleVariant;
  mq:IIngeoMapObjectsQuery;
  larid,objid:WideString;
  spi:integer;
begin
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(0,0,x2,y1);
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld
     (gAddon2.MainWindow.MapWindow.Surface.DeviceRight,
        gAddon2.MainWindow.MapWindow.Surface.DeviceBottom,x1,y2);
  strl:=TStringList.Create;
  xm:=NewXMLDocument();
  xm.Encoding:='UTF-8';
  mnode:=xm.AddChild(root);
  mnode.SetAttributeNS('X1','',x1);
  mnode.SetAttributeNS('Y1','',Y1);
  mnode.SetAttributeNS('X2','',X2);
  mnode.SetAttributeNS('Y2','',Y2);
  mapv:=gAddon2.ActiveProjectView.MapViews;
  for i := 0 to mapv.Count - 1 do
  begin
    if mapv.Item[i].Map.MapType<>inmtVector then
       continue;
    map:=mapv.Item[i].Map as IIngeoVectorMap;
    for li := 0 to map.Layers.Count - 1 do
    begin
      strl.Add(map.Layers.Item[li].ID);
//      CopyLayer(mnode,x1,y1,x2,y2,map.Layers.Item[li]);
    end;

  end;
  arr:=VarArrayFromStrings(strl);
  mq:=gAddon2.ActiveDb.MapObjects.QueryByRect(arr,x1,y1,x2,y2,True);
  while not mq.EOF do
  begin
    mq.Fetch(larid,objid,spi);
    AddObject(mnode,objid);
  end;
  Clipboard.SetTextBuf(xm.XML.GetText);
//  Clipboard.AsText:=xm.XML.GetText;
end;


procedure PasteWindow;
var xm:IXMLDocument;
    mnode,objnode,shpsnode:IXMLNode;
  i: Integer;
  mobjs:IIngeoMapObjects;
  objid:String;
begin
  if not Clipboard.HasFormat(CF_TEXT) then
  begin
    ShowMessage('Буфер обмена не содержит данных!');
    exit;
  end;
  xm:=NewXMLDocument;
  xm.LoadFromXML(Clipboard.AsText);
  mnode:=xm.ChildNodes.FindNode(root);
  if mnode=nil then
  begin
    ShowMessage('Буфер обмена не содержит скопированных данных!');
    exit;
  end;
  if MessageDlg('Внимание! Вставка может привести к изменению существующих объектов! Продолжить?',
     dialogs.mtConfirmation,[mbYes,mbNo],0)=ID_NO then exit;
  errreport:=TStringList.Create;
  mobjs:=gAddon2.ActiveDb.MapObjects;
//  shpsnode:=mnode.ChildNodes.F
  for i := 0 to mnode.ChildNodes.Count - 1 do
  begin
    objnode:=mnode.ChildNodes.Get(i);
    if CheckObject(objnode,mnode) then UpdateObject(mobjs,objnode) else
       CreateOneObject(mobjs,objnode);
  end;
  mobjs.UpdateChanges;
  if errreport.Count>0 then
  begin
    fCpReport:=TfCpReport.Create(nil);
    fCpReport.Memo1.Lines:=errreport;
    fcpReport.Show;
  end;
  errreport.Free;
end;

end.
