unit semtest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, Ingeo_TLB,Inscripting_TLB, M2Addon,M2AddonD;

type
  TfSemTest = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    sgSem: TStringGrid;
    Edit1: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    procedure Test1;
    procedure Test2;
  public
    { Public declarations }
  end;

var
  fSemTest: TfSemTest;

implementation
uses addn;
{$R *.dfm}

procedure TfSemTest.BitBtn1Click(Sender: TObject);
begin
  Test2;
end;

procedure TfSemTest.BitBtn2Click(Sender: TObject);
begin
  Test1;
end;

procedure TfSemTest.Test1;
var i:Cardinal;
    lar:IIngeoLayer;
    iq:IIngeoMapObjectsQuery;
    x1,y1,x2,y2:double;
    row,si,spi,dx,dy:integer;
    larid,oid:widestring;
    obj:IIngeoMapObject;
    mobjs:IIngeoMapObjects;
    st:IIngeoSemTable;
    tables,fields:TStringList;
  fi: Integer;
//  row: string;
begin

  i:=GetTickCount;
  lar:=Gaddon2.ActiveProjectView.ActiveLayerView.Layer;
  fields:=TStringList.Create;
  tables:=TStringList.Create;
  for si   := 0 to lar.SemTables .Count - 1 do
  begin
    st:=lar.SemTables.Item[si];
    for fi := 0 to st.FieldInfos.Count   - 1 do
    begin
      tables.Add(st.Name);
      fields.Add(st.FieldInfos.Item[fi].FieldName);
    end;
  end;

  dx:=gAddon2.MainWindow.MapWindow.Surface.DeviceRight;
  dy:=gAddon2.MainWindow.MapWindow.Surface.DeviceBottom;
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(0,dy,x1,y1);
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(dx,0,x2,y2);
  iq:=gAddon2.ActiveDb.MapObjects.QueryByRect(lar.ID,x1,y1,x2,y2,False);
  sgSem.RowCount:=10000;
  sgSem.ColCount:=tables.Count+1;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  row:=1;
  while not iq.EOF do
  begin
    iq.Fetch(larid,oid,spi);
    obj:=mobjs.GetObject(oid);
    for fi := 0 to tables.Count - 1 do
    begin
      sgSem.Cells[fi+1,row]:=obj.SemData.GetDisplayText(tables[fi],fields[fi],0);
    end;
    sgSem.Cells[0,row]:=IntToStr(row);
    inc(row);
  end;
  Edit1.Text:=IntToStr(GetTickCount-i);
end;

procedure TfSemTest.Test2;
var i:Cardinal;
    lar:IIngeoLayer;
    iq:IIngeoMapObjectsQuery;
    x1,y1,x2,y2:double;
    row,si,spi,dx,dy:integer;
    larid,oid:widestring;
    obj:IIngeoMapObject;
    mobjs:IIngeoMapObjects;
    st:IIngeoSemTable;
    idlist,tables,fields:TStringList;
    fi: Integer;
    tl:TList;
    stb:IIngeoSemDbTable;
    ds:IIngeoSemDbDataSet;
  cii: integer;
    s:string;
  wx: double;
  wy: double;
  wcv: double;
  shp:IIngeoShape;
  spl:IM2ShapeList;
  cont:IM2Contour;
  ccc: Integer;
  cmd: TM2ContourCommand;
  stid,pid:TM2ID;
//  row: string;
begin

  i:=GetTickCount;
  tl:=TList.Create;
  lar:=Gaddon2.ActiveProjectView.ActiveLayerView.Layer;
  fields:=TStringList.Create;
  tables:=TStringList.Create;
  idlist:=TStringList.Create;
  idlist.Sorted:=True;
  for si   := 0 to lar.SemTables .Count - 1 do
  begin
    st:=lar.SemTables.Item[si];
    tl.Add( Pointer(st.SemDBTable));
    for fi := 0 to st.FieldInfos.Count   - 1 do
    begin
      tables.Add(st.Name);
      fields.Add(st.FieldInfos.Item[fi].FieldName);
    end;
  end;
{  for si := 0 to lar.Styles.Count - 1 do
  begin
    if lar.Styles.Item[si]. then

  end;}
  pid:=lar.Styles.Item[0].ID;
  stb:=IIngeoSemDbTable(tl[0]);
  ds:=stb.SelectData('*','','');
  dx:=gAddon2.MainWindow.MapWindow.Surface.DeviceRight;
  dy:=gAddon2.MainWindow.MapWindow.Surface.DeviceBottom;
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(0,dy,x1,y1);
  gAddon2.MainWindow.MapWindow.Surface.PointDeviceToWorld(dx,0,x2,y2);
  iq:=gAddon2.ActiveDb.MapObjects.QueryByRect(lar.ID,x1,y1,x2,y2,False);
  sgSem.RowCount:=10000;
  sgSem.ColCount:=tables.Count+3;
  mobjs:=gAddon2.ActiveDb.MapObjects;
  row:=1;
  s:='';
  while not iq.EOF do
  begin
    iq.Fetch(larid,oid,spi);
    idlist.Add(oid);
  end;
  sgSem.RowCount:=idlist.Count+1;

    cii:=1;
//    for fi := 0 to tl.Count - 1 do
//    begin
      stb:=IIngeoSemDbTable(tl[0]);
      ds:=stb.SelectData('*',s,'');
      ds.MoveFirst;
      while not ds.EOF do
      begin
        if idlist.IndexOf( ds.Fields.Item['ID'].Value)<>1 then
        begin
          for sI := 0 to ds.Fields.Count - 1 do
          begin
            try
              sgSem.Cells[si+1,row]:=ds.Fields.Item[si].Value;
            except

            end;

          end;
          spl:=gAddon.MapObjects.GetObjectShapeList(sgSem.Cells[1,row]);
          spl.i_GetCount(ccc);
          for si := 0 to ccc - 1 do
          begin
            spl.i_GetContour(si,cont);
//            spl.i_GetStyleID(si,stid);
//            if stid=pid then
//            begin
               cont.i_GetFirstCommand(cmd);
              sgSem.Cells[sgSem.ColCount-2,row]:=FloatTostr(cmd.MoveTo.Point.X);
              sgSem.Cells[sgSem.ColCount-1,row]:=FloatTostr(cmd.MoveTo.Point.Y);
//            end;
          end;

{          obj:=mobjs.GetObject(sgSem.Cells[1,row]);
//          sgSem.Cells[sgSem.ColCount-2,row]:=FloatTostr(obj.X1);
//          sgSem.Cells[sgSem.ColCount-1,row]:=FloatTostr(obj.Y1);

          for si := 0 to obj.Shapes.Count - 1 do
          begin
            shp:=obj.shapes.Item[si];
            if shp.DefineGeometry then
            begin
              shp.Contour.Item[0].GetVertex(0,wx,wy,wcv);
              sgSem.Cells[sgSem.ColCount-2,row]:=FloatTostr(shp.Contour.);
              sgSem.Cells[sgSem.ColCount-1,row]:=FloatTostr(wy);
              break;
            end;
          end;}
          sgSem.Cells[0,row]:=IntToStr(row);
          inc(row);
        end;
        ds.MoveNext;
      end;

{      for sI := 0 to ds.Fields.Count - 1 do
      begin
        try
        sgSem.Cells[cii,row]:=ds.Fields.Item[si].Value;
        except

        end;
        inc(cii);
      end;

    end;  }
//    sgSem.Cells[0,row]:=IntToStr(row);
//    inc(row);
//  end;
  Edit1.Text:=IntToStr(GetTickCount-i);
end;

end.
