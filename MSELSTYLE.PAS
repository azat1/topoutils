unit MSELSTYLE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, addn , M2Addon, ImgList;

type
  TfMSelectStyle = class(TForm)
    trv1: TTreeView;
    Button1: TButton;
    Button2: TButton;
    ImageList1: TImageList;
    constructor Create(c:TComponent;stllist:TStringList);
    procedure FormCreate(Sender: TObject);
    procedure trv1DblClick(Sender: TObject);
    procedure trv1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    stls:TStringList;
    { Private declarations }
    procedure SelectLayer(n:TTreeNode);
    procedure SelectMap(n:TTreeNode);
    procedure UNSelectLayer(n:TTreeNode);
    procedure UNSelectMap(n:TTreeNode);
    procedure MakePArentSelect(n:TTreeNode);
    procedure UpdateList;
  public
    { Public declarations }
  end;

var
  fMSelectStyle: TfMSelectStyle;

implementation

{$R *.DFM}

procedure TfMSelectStyle.FormCreate(Sender: TObject);
var map,lar,tbl,obj,stl:TM2ID;
    mapl,stll:IM2IDsList;

    k,ccs,i,cc,cc1,j:integer;
    data:TM2ObjectData;
    attr:TM2LayerAttrs;
    mattr:TM2MapAttrs;
    tbls:PM2TableData;
    f,v:PM2Variant;
    tblattr:TM2TableAttrs;
    tname:String;
    m,n,sl:TTreeNode;
    sattr:TM2StyleAttrs;
    ps:PM2ID;
begin
  mapl:=gAddon.MapProject.GetMapList;
  mapl.i_GetCount(cc1);
  for j:=0 to cc1-1 do
  begin

//  map:=gAddon.MapProject.ActiveMap;
  mapl.i_GetItem(j,map);
  gAddon.GISDatabase.GetMapAttrs(map,mattr);
  m:=trv1.Items.Add(nil,mattr.Name);
  m.ImageIndex:=1;
  m.SelectedIndex:=1;//------
  gAddon.MapProject.GetLayerList(map).i_GetCount(cc);
  for i:=0 to cc-1 do
  begin
    gAddon.MapProject.GetLayerList(map).i_GetItem(i,lar);
    gAddon.GISDatabase.GetLayerAttrs(lar,attr);
    n:=trv1.Items.AddChild(m,attr.Name);
    n.ImageIndex:=1;
    n.SelectedIndex:=1;   //----------
    stll:=gAddon.GISDatabase.GetStyleList(lar);
    stll.i_GetCount(ccs);
    for k:=0 to ccs-1 do
    begin
      stll.i_GetItem(k,stl);
      gAddon.GISDatabase.GetStyle(stl).i_GetAttrs(sattr);
      sl:=trv1.Items.AddChild(n,sattr.Name);
      if stls.IndexOf(stl)=-1 then
        sl.ImageIndex:=1 else sl.ImageIndex:=2;

      New(ps);
      ps^:=stl;
      sl.Data:=ps;
      sl.SelectedIndex:=sl.ImageIndex;    //----------------
    end;
    MakePArentSelect(n);
  end;
   MakePArentSelect(m);
  end;

end;

procedure TfMSelectStyle.trv1DblClick(Sender: TObject);
begin
  if trv1.Selected.Level=2 then
  begin
//    ModalREsult:=mrOk;
  end;
end;

procedure TfMSelectStyle.trv1Click(Sender: TObject);
begin
  if trv1.Selected.Level=2 then
  begin
    if trv1.Selected.ImageIndex=1 then
      trv1.Selected.ImageIndex:=2 else
        trv1.Selected.ImageIndex:=1;
    MakeParentSelect(trv1.Selected.Parent);
    MakeParentSelect(trv1.Selected.Parent.Parent);
  end;
  if trv1.Selected.Level=1 then
  begin
    if trv1.Selected.ImageIndex=2 then
    UnSelectLayer(trv1.Selected) else SelectLayer(trv1.Selected);
    MakeParentSelect(trv1.Selected.Parent);
  end;
  if trv1.Selected.Level=0 then
  begin
    if trv1.Selected.ImageIndex=2 then
    UnSelectMap(trv1.Selected) else SelectMap(trv1.Selected);
  end;
  trv1.Selected.SelectedIndex:=trv1.Selected.ImageIndex;
end;

procedure TfMSelectStyle.MakePArentSelect(n: TTreeNode);
var i,f,z:integer;

begin
  f:=0;    z:=0;
  for i:=0 to n.Count-1 do
  begin
    if n.Item[i].ImageIndex=2 then inc(f);
    if n.Item[i].ImageIndex=0 then inc(z);
  end;
  if f=n.Count then
        n.ImageIndex:=2;

  if (f<n.Count) and (f>0) then
        n.ImageIndex:=0;

  if (f=0) then
        n.ImageIndex:=1;
  if (z>0) then
        n.ImageIndex:=0;
  n.SelectedIndex:=n.ImageIndex;
end;

procedure TfMSelectStyle.SelectLayer(n: TTreeNode);
var i:integer;
begin
  for i:=0 to n.Count-1 do
  begin
    n.Item[i].SelectedIndex:=2;
    n.Item[i].ImageIndex:=2;
  end;
  n.SelectedIndex:=2;
  n.ImageIndex:=2;

end;

procedure TfMSelectStyle.SelectMap(n: TTreeNode);
var i:integer;
begin
  n.SelectedIndex:=2;
  n.ImageIndex:=2;
  for i:=0 to n.Count-1 do
  begin
    n.Item[i].SelectedIndex:=2;
    n.Item[i].ImageIndex:=2;
    SelectLayer(n.Item[i]);
  end;
end;

procedure TfMSelectStyle.UNSelectLayer(n: TTreeNode);
var i:integer;
begin
  for i:=0 to n.Count-1 do
  begin
    n.Item[i].SelectedIndex:=1;
    n.Item[i].ImageIndex:=1;
  end;
  n.SelectedIndex:=1;
  n.ImageIndex:=1;

end;

procedure TfMSelectStyle.UNSelectMap(n: TTreeNode);
var i:integer;
begin
  n.SelectedIndex:=1;
  n.ImageIndex:=1;
  for i:=0 to n.Count-1 do
  begin
    n.Item[i].SelectedIndex:=1;
    n.Item[i].ImageIndex:=1;
    UnSelectLayer(n.Item[i]);
  end;
end;

constructor TfMSelectStyle.Create(c: TComponent; stllist: TStringList);
begin
  stls:=stllist;
  inherited Create(c);

end;

procedure TfMSelectStyle.Button1Click(Sender: TObject);
begin
  UpdateList;
end;

procedure TfMSelectStyle.UpdateList;
var m,l,s:integer;
begin
  stls.Clear;
  for m:=0 To trv1.Items.Count-1 do
  begin
    for l:=0 to trv1.Items.Item[m].Count-1 do
    begin
      for s:=0 to trv1.Items.Item[m].Item[l].Count-1 do
      begin
        if trv1.Items.Item[m].Item[l].Item[s].ImageIndex=2 then
          stls.Add(PM2ID(trv1.Items.Item[m].Item[l].Item[s].Data)^);
      end;
    end;
  end;
end;

end.
