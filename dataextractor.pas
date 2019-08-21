unit dataextractor;

interface
uses Classes, SysUtils, dialogs, dbtables, Ingeo_TLB, StdCtrls;
type
  TCoord=packed record
    x,y:double;
  end;

  TFCoord=class
    x,y,cv:double;
    constructor Create(x,y,cv:double);
  end;
  TFContourPart=class(tList)
    public
      closed:boolean;
      constructor Create;
      procedure AddPoint(x,y,cv:double);
      function GetPoint(i:integer):TFCoord;
  end;
  TFContour=class(TList)
    public
      function AddContourPart():TFContourPart;
      function GetContourPart(i:integer):TFContourPart;
  end;
  TFSemRecord=class
    public
      table,field,value:string;
  end;
  TFSemData=class(TList)
    public
      procedure AddData(table,field,value:string);
      function GetValue(i:integer):TFSemRecord;
  end;

  TFShape=class
    public
      styleid:string;
      contour:TFContour;
  end;

  TFShapes=class(TList)
    public
      function AddShape(styleid:string;contour:TFContour):TFShape;
      function Getshape(i:integer):TFShape;
  end;

  TFObject=class
    public
      objid:string;
      semdata:TFSemData;
      shapes:TFShapes;
      constructor Create;
      function InRect(x1,y1,x2,y2:double):boolean;
  end;

  TFObjectList=class(TList)
    public
      function GetObject(i:integer):TFObject;
      function GetObjectbyID(id:string):TFObject;
      function GetObjectbyIDFast(id:string):TFObject;
      procedure AddShape(objid:string;styleid:string;contour:TfContour);
      procedure PushSemdata(objid:string;tablename,fieldname,value:string);
      procedure AddSorted(obj:TFObject);
  end;

  PCoord=^TCoord;
  TDBExtractor=class
    public
      app:IIngeoApplication;
      dbdir,semdir:string;
      db:TDataBase;
      res:TMemoryStream;
      objects:TFObjectList;
      progresslabel:TLabel;
      constructor Create(dbdir,semdir:string);
      procedure ExtractData;
      procedure LoadSemData;
      procedure LoadSemTable(name:string);
      function GetSemFileList:TStringList;
      procedure LoadSectorData;
      procedure FindObjects(data:PByte;len:integer);
      procedure PushContour(objid,stlid:string;contour:TFContour);
      procedure PrintResult;
      procedure CreateObjects;
      procedure CreateOneObject(mobjs:IIngeoMapObjects;obj:TFObject);
      procedure SetSemData(mobj:IIngeoMapObject;obj:TFObject);
      function SemDBtoTable(larid:string;tdbname:string):string;
      function IsOnetoOne(larid:string;tname:string):boolean;
    private
      sectordata:^byte;
      function IsHex(b:byte):boolean;
      function HaveId(data:PByte):string;
    procedure PushCoords(objid, stlid: string; count: integer; coord: PCoord);

  end;

implementation

function ObjectIdcompare(p1,p2:pointer):integer;
var obj1,obj2:TFObject;
begin
  obj1:=TFObject(p1);
  obj2:=TFObject(p2);
  if obj1.objid>obj2.objid then  Result:=1;
  if obj1.objid<obj2.objid then  Result:=-1;
  if obj1.objid=obj2.objid then  Result:=0;


end;

function PointInRect(x,y,x1,y1,x2,y2:double):boolean;
begin
  Result:=(x>x1)and(x<x2)and(y>y1)and(y<y2);
end;

{ TDBExtractor }

constructor TDBExtractor.Create(dbdir, semdir: string);
begin
  self.dbdir:=dbdir;
  self.semdir:=semdir;
  objects:=TFObjectList.Create;
end;

procedure TDBExtractor.CreateObjects;
var
  i: Integer;
  mobjs:IIngeoMapObjects;
begin
  mobjs:=app.ActiveDb.MapObjects;
  for i := 0 to objects.Count - 1 do
  begin
    if (i mod 500)=0 then
    begin
      mobjs.UpdateChanges;
      progresslabel.Caption:=IntTostr(i)+'/'+IntTostr(objects.Count);
      app.ProcessMessages;
    end;
    CreateOneObject(mobjs,objects.GetObject(i));
  end;
  mobjs.UpdateChanges;
end;

procedure TDBExtractor.CreateOneObject(mobjs: IIngeoMapObjects; obj: TFObject);
var
  stlid,larid: string;
  mobj: IIngeoMapObject;
  i: Integer;
  shp: TFShape;
  ishp: IIngeoShape;
  ci: Integer;
  cntp: TFContourPart;
  icntp: IIngeoContourPart;
  vi: Integer;
  pnt: TFCoord;
begin
  if obj.shapes.Count=0 then
    exit;
  stlid:=obj.shapes.Getshape(0).styleid;
  if app.ActiveDb.StyleExists(stlid) then
    larid:= app.ActiveDb.StyleFromID(stlid).Layer.ID else exit;

  if not obj.InRect(500000,2000000,700000,3000000) then
    exit;
  mobj:=mobjs.AddObject(larid);
  for i := 0 to obj.shapes.Count - 1 do
  begin
    shp:=obj.shapes.Getshape(i);
    if not app.ActiveDb.StyleExists(shp.styleid) then
      continue;
    ishp:= mobj.Shapes.Insert(-1,shp.styleid);
    for ci := 0 to shp.contour.Count - 1 do
    begin
      cntp:=shp.contour.GetContourPart(ci);
      icntp:=ishp.Contour.Insert(-1);
      for vi := 0 to cntp.Count - 1 do
      begin
        pnt:=cntp.GetPoint(vi);
        icntp.InsertVertex(-1,pnt.x,pnt.y,0);
      end;
      icntp.Closed:= cntp.closed;// then

    end;

  end;
  SetSemData(mobj,obj);

end;

procedure TDBExtractor.ExtractData;
var n:byte;
begin
  LoadSectorData;
  LoadSemData;
  PrintResult;
  n:=0;
  res.WriteBuffer(n,1);
  
end;

procedure TDBExtractor.FindObjects(data: PByte;len:integer);
label t45;
var enddata,tdata:PByte;
    styleid:string;
    objid:string;
  i: Integer;
  coordsize:pinteger;
  coordcount:integer;
  px,py:pdouble;
  coords:PCoord;
  shapecount:PWord;
  commandcount:PInteger;
  command: byte;
  contour:TFContour;
  commandmulti: byte;
  cmi: Integer;
  cntp: TFContourPart;
  coords2,gabs: PCoord;
  arcdata: PDouble;
  commandend: PByte;
  obj:TFObject;
begin

  if len=0 then
   exit;
  try
  res:=TMemoryStream.Create;
  enddata:=data;
  inc(enddata,len);
 /// enddata:=(data+len);
  while NativeInt( data)<NativeInt(enddata) do
  begin
   // while True do


    while (NativeInt( data)<NativeInt(enddata)) and  (HaveId(data)='') do
    begin
      inc(data);
    end;
    objid:=HaveId(data);
    obj:=TFObject.Create;
    obj.objid:=objid;
    objects.AddSorted(obj);
    inc(data,13);

    //проверить в 4*8=32 байтах впереди нету другого id
    tdata:=data;
    if (NativeInt(enddata)- NativeInt(tdata))<32 then
      continue;
    for i := 0 to 31 do
    begin

      if HaveId(tdata)<>'' then
        continue;
      inc(tdata);
    end;
    gabs:=PCoord(data);
    //проверка реальности габаритов
    if (gabs.x<1e-7) or (gabs.y>1e7) then
       continue;
    //32 байта габариты - пропускаем
    inc(data,32);
    shapecount:=Pword(data);
    //2 байта флажков - пропускаем
    inc(data,2);
    for i := 0 to shapecount^ - 1 do
    begin
      // contour
      //4 байт integer размер блока координат
      coordsize:=PInteger( data);
     // проверка реальности блока координат
      if (coordsize^>65536) or (coordsize^<0) then
       break;

      coordcount:=coordsize^ div 16;
      inc(data,4);
      coords:=PCoord(data);
      inc(data,coordsize^);
      commandcount:=PInteger(data);
      if (commandcount^>10000) or (commandcount^<0) then break;

      inc(data,4);
      contour:=TFContour.Create;
      coords2:=coords;
      commandend:=PByte(NativeInt(data)+commandcount^);

      while NativeInt(data)<NativeInt(commandend) do// for i := 0 to commandcount - 1 do
      begin
        command:=data^;
        case command of
          0:begin        //moveto
              inc(data);
              commandmulti:=data^;
              inc(data);
              for cmi  := 1 to commandmulti do
              begin
                cntp:=contour.AddContourPart;
                cntp.AddPoint(coords2^.x,coords2^.y,0);
                inc(coords2);
              end;
            end;
          1:begin  //line to
              inc(data);
              commandmulti:=data^;
              inc(data);
              for cmi  := 1 to commandmulti do
              begin
                //cntp:=contour.AddContourPart;
                cntp.AddPoint(coords2^.x,coords2^.y,0);
                inc(coords2);
              end;
            end;
          2:begin //arc to
              inc(data);
              commandmulti:=data^;
              inc(data);
              arcdata:=PDouble(data);
              inc(data,8);
              for cmi  := 1 to commandmulti do
              begin
                //cntp:=contour.AddContourPart;
                cntp.AddPoint(coords2^.x,coords2^.y,arcdata^);
                inc(coords2);
              end;

            end;
           3:begin//closebyline
               cntp.closed:=true;
               inc(data);
             end;
           4:begin
               //closebyarc
               cntp.closed:=true;
               inc(data,9);

             end;
           else  goto t45;
        end; //case

      end; //while

      styleid:=HaveId(data);
      obj.shapes.AddShape(styleid,contour);
     // PushContour(objid,styleid,contour);
      inc(data,13);

//      //проверка на id на дистанции 20 байтов (4 размер блока + 16 б минимальные координаты
//      tdata:=data;
//      for i := 0 to 31 do
//      begin
//        if HaveId(tdata)<>'' then
//          continue;
//        inc(tdata);
//      end;
    end; //for //until (NativeInt( data)<NativeInt(enddata));
        t45:
  end;


  except
    on e:Exception do
    begin
       ShowMessage('dfdgd');
    end;
  end; //while

end;

function TDBExtractor.GetSemFileList: TStringList;
var spath:string;
    attr:integer;
    f:TSearchRec;
begin
  Result:=TStringList.Create;
  spath:=semdir+'\*.db';
  if FindFirst(spath,0,f)=0 then
  begin
    Result.Add(f.Name);
    while FindNext(f)=0 do
    begin
      Result.Add(f.Name);
    end;
  end;
  FindClose(f);
  //if f. then

end;

function TDBExtractor.HaveId(data: PByte): string;
var
  i: Integer;
  s:string;
begin
  Result:='';
  if data^<>$0C then exit;
  s:='';
  for i := 1 to 12 do
  begin
    inc(data);
    if not IsHex(data^) then
    begin
      exit;
    end;
    s:=s+chr((data)^);
  end;
  Result:=s;
end;

function TDBExtractor.IsHex(b: byte): boolean;
begin
  if (b>=Ord('0')) and (b<=Ord('9')) then
  begin
    Result:=true;
    exit;
  end;
  if (b>=Ord('A')) and (b<=Ord('F')) then
  begin
    Result:=true;
    exit;
  end;
  REsult:=false;
end;

function TDBExtractor.IsOnetoOne(larid, tname: string): boolean;
var
  lar: IIngeoLayer;
  i: Integer;
begin
  lar:=app.ActiveDb.LayerFromID(larid);
  for i := 0 to lar.SemTables.Count - 1 do
  begin
    if tname=lar.SemTables[i].Name then
    begin
      if lar.SemTables[i].LinkType=0 then
      begin
        Result:=true;
      end else
        Result:=false;
      exit;
    end;
  end;
  Result:=false;
end;

procedure TDBExtractor.LoadSectorData;
var fname:string;
    fstream:TFileStream;
    size:integer;
begin
  try
  fname:=dbdir+'\ingeo_sectors.mb';
  fstream:=TFileStream.Create(fname,fmOpenRead or fmShareDenyNone);
  size:=fstream.Size;
  GetMem(sectordata,fstream.Size);
  fstream.ReadBuffer(sectordata^,fstream.Size);
  fstream.Free;
  except
    on e:Exception do
      begin
        fstream.Free;
        FreeMem(sectordata);
        exit;
      end;
  end;
  FindObjects(PByte( sectordata),size);



end;

procedure TDBExtractor.LoadSemData;
var semfilelist:TStringList;
  i: Integer;
begin
  objects.Sort(ObjectIdCompare);
  semfilelist:=GetSemFileList();
  for i := 0 to semfilelist.Count - 1 do
  begin
    LoadSemTable(semfilelist[i]);
  end;

end;

procedure TDBExtractor.LoadSemTable(name: string);
var tbl:TTable;
    db:TDatabase;
    id,tbname,fieldname,value:string;
  i: Integer;
begin
//  db:=TDatabase.Create(nil);
//  db.DatabaseName:=semdir;
//  db.Open;
  try
    tbl:=TTable.Create(nil);
 //   tbl.DatabaseName:=ExtractFilePath(name);
    tbl.TableName:=semdir+'\'+ name;
    tbname:= ExtractFileName(name);
    tbname:=Copy(tbname,1,Length(tbname)-3);


    tbl.Active:=true;
    tbl.First;
    //if True then
    while not tbl.Eof do
    begin
      id:= tbl.Fields[0].AsString;
      if id<>'' then
      begin
        for i := 1 to tbl.Fields.Count - 1 do
        begin
          fieldname:=tbl.FieldDefs[i].Name;
          value:=tbl.Fields[i].AsString;
          objects.PushSemData(id,tbname,fieldname,value);
        end;
      end;
      tbl.Next;
    end;

    tbl.Active:=false;
    tbl.Free;
  except
     on e:Exception do
     begin
       ShowMessage('table error! '+e.Message);
     end;
  end;

//    db.Close;
end;

procedure TDBExtractor.PrintResult;
var s:string;
  I: Integer;
  obj: TFObject;
  si: Integer;
  shp: TFShape;
  ci: Integer;
  cntp: TFContourPart;
  pp: Integer;
  pnt: TFCoord;
  semd: TFSemRecord;
begin
  s:=format('%d objects'#13#10,[objects.Count]);
  res.WriteBuffer(s[1],Length(s));

  for I := 0 to objects.Count - 1 do
  begin
    obj:=objects.GetObject(i);
    s:=format('object id= %s '#13#10,[obj.objid]);
    res.WriteBuffer(s[1],Length(s));
    for si := 0 to obj.semdata.Count - 1 do
    begin
      semd:=obj.semdata.GetValue(si);
      s:=format('  %s= %s '#13#10,[semd.table+'.'+semd.field,semd.value]);
      res.WriteBuffer(s[1],Length(s));

    end;


    for si := 0 to obj.shapes.Count - 1 do
    begin
      shp:=obj.shapes.Getshape(si);
      s:=format('  shape %d id= %s '#13#10,[si, shp.styleid]);
      res.WriteBuffer(s[1],Length(s));
      for ci := 0 to shp.contour.Count - 1 do
      begin
        cntp:=shp.contour.GetContourPart(ci);
        s:=format('    cntrp %d closed %s'#13#10,[ci, BoolToStr( cntp.closed)]);
        res.WriteBuffer(s[1],Length(s));

        for pp := 0 to cntp.Count - 1 do
        begin
          pnt:=cntp.GetPoint(pp);
          s:=format('    %.2f #.2f'#13#10,[pnt.x, pnt.y]);
          res.WriteBuffer(s[1],Length(s));

        end;

      end;

    end;

  end;

end;

procedure TDBExtractor.PushContour(objid, stlid: string; contour:TFContour);
var s:string;
  i: Integer;
  tcoord:PCoord;
  cntp: TFContourPart;
  j: Integer;
  pnt: TFCoord;
begin
  s:='ObjectId='+objid+'; StyleID='+stlid+#13#10;

  res.WriteBuffer(s[1],Length(s));

  for i := 0 to contour.Count - 1 do
  begin
    cntp:=contour.GetContourPart(i);
    s:=Format('-------'#13#10,[1]);
    res.WriteBuffer(s[1],Length(s));

    for j := 0 to cntp.Count - 1 do
    begin
      pnt:=cntp.GetPoint(j);
      s:=Format('%.2f  %.2f'+#13#10,[ pnt.x,pnt.y]);
      res.WriteBuffer(s[1],Length(s));
    end;
    if cntp.closed then
    begin
      s:=Format('closed'+#13#10,[ pnt.x]);
      res.WriteBuffer(s[1],Length(s));

    end;
    //inc(tcoord);
  end;
  s:='============'#13#10;
  res.WriteBuffer(s[1],Length(s));

end;

procedure TDBExtractor.PushCoords(objid, stlid: string; count: integer; coord: PCoord);
begin

end;

function TDBExtractor.SemDBtoTable(larid, tdbname: string): string;
var sts:IIngeoSemTables;
    i:integer;
begin
  sts:=app.ActiveDb.LayerFromID(larid).SemTables;
  for i := 0 to sts.Count - 1 do
  begin
    if sts[i].SemDbTableName=tdbname then
    begin
      Result:=sts[i].Name;
      exit;
    end;
  end;
  Result:='';
end;

procedure TDBExtractor.SetSemData(mobj: IIngeoMapObject; obj: TFObject);
var
  i: Integer;
  srec: TFSemRecord;
  itname:string;
begin
  if obj.semdata.Count=0 then
    exit;
  for i := 0 to obj.semdata.Count - 1 do
  begin
    srec:=obj.semdata.GetValue(i);
    itname:=SemDBtoTable(mobj.LayerID, srec.table);
    if itname='' then
      continue;
  //  mobj.SemData.GetRecCount()
    if IsOneToOne(mobj.LayerID,itname) then
      mobj.SemData.SetValue(itname,srec.field,srec.value,0);
  end;
end;

{ TFCoord }

constructor TFCoord.Create(x, y, cv: double);
begin
  self.x:=x;self.y:=y;self.cv:=cv;
end;

{ TFContourPart }

procedure TFContourPart.AddPoint(x, y, cv: double);
begin
  Add(TFCoord.Create(x,y,cv));
end;

constructor TFContourPart.Create;
begin
  closed:=false;
end;

function TFContourPart.GetPoint(i: integer): TFCoord;
begin
  Result:=TFCoord(Items[i]);
end;

{ TFContour }

function TFContour.AddContourPart: TFContourPart;
//var obj:TFContourPart;
begin
  Result:=TFContourPart.Create;
  Add(Result);

end;

function TFContour.GetContourPart(i: integer): TFContourPart;
begin
  Result:=TFContourPart(Items[i]);
end;

{ TFShapes }

function TFShapes.AddShape(styleid: string; contour: TFContour): TFShape;
var shp:TFShape;
begin
  shp:=TFShape.Create;
  shp.styleid:=styleid;
  shp.contour:=contour;
  Add(shp);
end;

function TFShapes.Getshape(i: integer): TFShape;
begin
  Result:=TFShape(Items[i]);
end;

{ TFObjectList }

procedure TFObjectList.AddShape(objid, styleid: string; contour: TfContour);
var obj:TFObject;
begin
  obj:=GetObjectbyID(objid);
  if obj=nil then
  begin
    obj:=TFObject.Create;
    obj.objid:=objid;
    Add(obj);
  end;
  obj.shapes.AddShape(styleid,contour);

end;

procedure TFObjectList.AddSorted(obj: TFObject);
var a,b,c:integer;
    id:string;
begin
  Add(obj);

end;
//var
//  i: Integer;
//begin
//  if count=0 then
//  begin
//    Add(obj);exit;
//  end;
//  for i := 0 to Count - 1 do
//  begin
//    if obj.objid>GetObject(i).objid then
//    begin
//      Insert(i,obj);
//      exit;
//    end;
//  end;
//end;

function TFObjectList.GetObject(i: integer): TFObject;
begin
   Result:=TFObject(Items[i]);
end;

function TFObjectList.GetObjectbyID(id: string): TFObject;
var
  i: Integer;
  obj:TFObject;
begin
  for i := 0 to Count - 1 do
  begin
    obj:=GetObject(i);
    if obj.objid=id then
    begin
      Result:=obj;
      exit;
    end;

  end;
  Result:=nil;
end;

function TFObjectList.GetObjectbyIDFast(id: string): TFObject;
var a,b,c:integer;
begin
  a:=0;
  b:=Count-1;
  repeat
  c:=(a+b) div 2;
//  if (b-a)=0 then
//  begin
//  end;
    if GetObject(c).objid=id then
    begin
      Result:=GetObject(c); exit;
    end;// else
      //Result:=nil;

  if GetObject(c).objid>id then
   b:=c else a:=c;
  until (b-a)=1;
  Result:=nil;
end;

procedure TFObjectList.PushSemdata(objid, tablename, fieldname, value: string);
var
  i: Integer;
  obj: TFObject;
begin
  if value='' then
    exit;
  obj:=GetObjectbyIDFast(objid);
  if obj=nil then
    exit;

 // for i := 0 to Count - 1 do
 // begin
 //   if objid=GetObject(i).objid then
 //   begin
  obj.semdata.AddData(tablename,fieldname,value);
     // exit;
   // end;
 // end;

end;

{ TFObject }

constructor TFObject.Create;
begin
  semdata:=TFSemData.Create;
  shapes:=TFShapes.Create;
end;

function TFObject.InRect(x1, y1, x2, y2: double): boolean;
var
  i: Integer;
  shp: TFShape;
  ci: Integer;
  cntr: TFContourPart;
  vi: Integer;
  pnt: TFCoord;
begin
  for i := 0 to shapes.Count - 1 do
  begin
    shp:=shapes.Getshape(i);
    for ci := 0 to shp.contour.Count - 1 do
    begin
      cntr:=shp.contour.GetContourPart(ci);
      for vi := 0 to cntr.Count - 1 do
      begin
        pnt:=cntr.GetPoint(vi);
        if not PointInRect(pnt.x,pnt.y,x1,y1,x2,y2) then
        begin
          Result:=false;
          exit;
        end;
      end;
    end;

  end;
  Result:=true;
end;

{ TFSemData }

procedure TFSemData.AddData(table, field, value: string);
var tss:TFSemRecord;
begin
  tss:=TFSemRecord.Create;
  tss.table:=table;
  tss.field:=field;
  tss.value:=value;
  Add(tss);
end;

function TFSemData.GetValue(i: integer): TFSemRecord;
begin
  Result:=TFSemRecord(Items[i]);
end;

end.
