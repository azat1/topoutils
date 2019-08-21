unit splitter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dllform, StdCtrls, Ingeo_TLB;

type
  TfSplitter = class(TM2AddonForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    procedure MakeDivide;
    procedure DivideOneObject(mobj:IIngeoMapObject);
    procedure AddNewObjectPart(mobj:IIngeoMapObject;StyleID:string;cntp:IIngeoContourPart);
    procedure CopySemData(sobj,dobj:IIngeoMapObject);
    procedure AddOneContour(cntrs:TInterfaceList;cntp:IIngeoContourPart);
    procedure InsertCntp(cntr:IIngeoContour;cntp:IIngeoContourPart);
    procedure AddNewObjectParts(mobj:IIngeoMapObject;StyleID:string;cntrs:TInterfaceList);


  public
    mobjs:IIngeoMapObjects;
    { Public declarations }
  end;

var
  fSplitter: TfSplitter;

implementation
uses addn;
{$R *.dfm}

procedure TfSplitter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;

end;

procedure TfSplitter.InsertCntp(cntr: IIngeoContour; cntp: IIngeoContourPart);
var i:integer;
  x,y,cv:double;
  vv:IIngeoContourPart;
begin
  vv:=cntr.Insert(-1);
  for i := 0 to cntp.VertexCount - 1 do
  begin
    cntp.GetVertex(i,x,y,cv);
    vv.InsertVertex(-1,x,y,cv);
  end;
  vv.Closed:=cntp.Closed;
end;

procedure TfSplitter.MakeDivide;
var
  i: Integer;
  mobj: IIngeoMapObject;
begin
  mobjs:=gAddon2.ActiveDb.MapObjects;
  for i := 0 to gAddon2.Selection.Count - 1 do
  begin
    mobj:=mobjs.GetObject(gAddon2.Selection.IDs[i]);
    DivideOneObject(mobj);
  end;
    mobjs.UpdateChanges;

end;

procedure TfSplitter.AddNewObjectPart(mobj: IIngeoMapObject; StyleID: string; cntp: IIngeoContourPart);
var nobj:IIngeoMapObject;
  shp: IIngeoShape;
  cntpp:IIngeoContourPart;
  I: Integer;
  x,y,cv:double;
begin
  nobj:=mobjs.AddObject(mobj.LayerID);
  shp:=nobj.Shapes.Insert(-1,StyleID);
  cntpp:=shp.Contour.Insert(-1);

  for I := 0 to cntp.VertexCount - 1 do
  begin
    cntp.GetVertex(i,x,y,cv);
    cntpp.InsertVertex(-1,x,y,cv);
  end;
  cntpp.Closed:=cntp.Closed;
  CopySemData(mobj,nobj);
end;

procedure TfSplitter.AddNewObjectParts(mobj: IIngeoMapObject; StyleID: string; cntrs: TInterfaceList);
var
  I: Integer;
  nobj: IIngeoMapObject;
  shp: IIngeoShape;
begin
  for I := 0 to cntrs.Count - 1 do
  begin
    nobj:=mobjs.AddObject(mobj.LayerID);
    shp:=nobj.Shapes.Insert(-1,StyleID);
    shp.Contour.AddPartsFrom(IIngeoContour(cntrs[i]));
    mobjs.UpdateChanges;
    CopySemData(mobj,nobj);
    mobjs.UpdateChanges;
  end;

end;

procedure TfSplitter.AddOneContour(cntrs: TInterfaceList; cntp: IIngeoContourPart);
var cntr,cntr2:IIngeoContour;
  i: Integer;
begin
  if not cntp.IsHole then
  begin
    cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
    InsertCntp(cntr,cntp);
    cntrs.Add(cntr);
  end else
  begin
    cntr:=gAddon2.CreateObject(inocContour,0) as IIngeoContour;
    InsertCntp(cntr,cntp);
    for i := 0 to cntrs.Count - 1 do
    begin
      cntr2:=cntrs[i] as IIngeoContour;
      if cntr2.Square>cntr.Square then
          cntr2.Combine(inccSub,cntr);
    end;
  end;
end;

procedure TfSplitter.Button1Click(Sender: TObject);
var newobj,obj:IIngeoMapObject;
    shp,newshp:IIngeoShape;
    newcntp:IIngeoContourPart;
    i,si,vi:integer;
    sname:string;
    tn,fn:TStringList;
    alar:IIngeoLayer;
    st:IIngeoSemTable;
    mobjs:IIngeoMapObjects;
    x,y,cv:Double;
begin
  mobjs:=gAddon2.ActiveDb.MapObjects;
  tn:=TStringList.Create;
  fn:=TStringList.Create;
  alar:=gAddon2.ActiveProjectView.ActiveLayerView.Layer;
  for i:=0 to alar.SemTables.Count-1 do
  begin
    st:=alar.SemTables.Item[i];
    for si:=0 to st.FieldInfos.Count-1 do
    begin
      if st.FieldInfos.Item[si].FieldName='ID' then continue;
      tn.Add(st.Name);
      fn.Add(st.FieldInfos.Item[si].FieldName);
    end;
  end;
  obj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[0]);
  for i:=0 to obj.Shapes.Count-1 do
  begin
    shp:=obj.Shapes.Item[i];
    sname:=shp.Style.Name;
    Memo1.Lines.Add('shape 1 '+sname+IntToStr(shp.Contour.Count));
    for si:=0 to shp.Contour.Count-1 do
    begin
      newobj:=mobjs.AddObject(alar.ID);
      newshp:=newobj.Shapes.Insert(0,shp.StyleID);
      newcntp:= newshp.Contour.Insert(0);
      for vi:=0 to shp.Contour.Item[si].VertexCount-1 do
      begin
        shp.Contour.Item[si].GetVertex(vi,x,y,cv);
        newcntp.InsertVertex(newcntp.VertexCount,x,y,cv);
      end;
      newcntp.Closed:=shp.Contour.Item[si].Closed;
      for vi:=0 to tn.Count-1 do
      begin
        newobj.SemData.SetValue(tn[vi],fn[vi],obj.SemData.GetValue(tn[vi],fn[vi],0),0);
      end;

    end;
  end;
  mobjs.UpdateChanges;
  tn.Free;
  fn.Free;
end;

procedure TfSplitter.Button2Click(Sender: TObject);
var newobj,obj:IIngeoMapObject;
    shp,newshp:IIngeoShape;
    newcntp:IIngeoContourPart;
    i,si,vi,cc:integer;
    sname:string;
    tn,fn:TStringList;
    alar:IIngeoLayer;
    st:IIngeoSemTable;
    mobjs:IIngeoMapObjects;
    x,y,cv:Double;
begin
  alar:=gAddon2.ActiveProjectView.ActiveLayerView.Layer;
  obj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[0]);
  for i:=0 to obj.Shapes.Count-1 do
  begin
    shp:=obj.Shapes.Item[i];
    sname:=shp.Style.Name;
    cc:=0;
    for si:=0 to shp.Contour.Count-1 do
    begin
      newcntp:= shp.Contour.Item[si];
      if not newcntp.IsHole then inc(cc);
    end;
    Memo1.Lines.Add('shape '+IntToStr(cc));
  end;
end;

procedure TfSplitter.Button3Click(Sender: TObject);
begin
  MakeDivide;
end;

procedure TfSplitter.CopySemData(sobj, dobj: IIngeoMapObject);
var
  I: Integer;
  sdata:IIngeoSemTables;
  st:IIngeoSemTable;
  fi: Integer;
begin

  sdata:=gAddon2.ActiveDb.LayerFromID(sobj.LayerID).SemTables;

  for I := 0 to sdata.Count - 1 do
  begin
    st:=sdata[i];
    for fi := 0 to st.FieldInfos.Count - 1 do
    begin
      dobj.SemData.SetValue(st.Name,st.FieldInfos[fi].FieldName,
        sobj.SemData.GetValue(st.Name,st.FieldInfos[fi].FieldName,0),0);
    end;
  end;

end;

procedure TfSplitter.DivideOneObject(mobj: IIngeoMapObject);
var
  si: Integer;
  shp: IIngeoShape;
  ci: Integer;
  cntp: IIngeoContourPart;
  cntrs:TInterfaceList;
begin
  cntrs:=TInterfaceList.Create;
  for si := 0 to mobj.Shapes.Count - 1 do
  begin
    shp:=mobj.Shapes[si];
    cntrs.Clear;
    for ci := 0 to shp.Contour.Count - 1 do
    begin
      cntp:=shp.Contour[ci];
      if not cntp.Closed then
      begin
        AddNewObjectPart(mobj,shp.StyleID,cntp);
      end else
      begin
        AddOneContour(cntrs,cntp);
      end;

    end;
    AddNewObjectParts(mobj,shp.StyleID,cntrs);
  end;
  mobjs.DeleteObject(mobj.ID);
end;

end.
